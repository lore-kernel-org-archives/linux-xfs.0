Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5C6377CA2
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 05:43:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D8B78F8054
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 03:42:58 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id oURSEfVTYMqIJoFA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 18 May 2016 03:42:56 -0700 (PDT)
Date: Wed, 18 May 2016 13:42:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: xfs: fix efi/efd error handling to avoid fs shutdown hangs
Message-ID: <20160518104239.GA11591@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: bfoster@redhat.com
Cc: xfs@oss.sgi.com

Hello Brian Foster,

The patch 8d99fe92fed0: "xfs: fix efi/efd error handling to avoid fs
shutdown hangs" from Aug 19, 2015, leads to the following static
checker warning:

	fs/xfs/xfs_bmap_util.c:134 xfs_bmap_finish()
	warn: error is never (-117)

fs/xfs/xfs_bmap_util.c
   120          error = __xfs_trans_roll(tp, ip, &committed);

It used to be that error was set by xfs_free_extent() which does return
-EFSCORRUPTED.  But I don't think __xfs_trans_roll() can.

   121          if (error) {
   122                  /*
   123                   * If the transaction was committed, drop the EFD reference
   124                   * since we're bailing out of here. The other reference is
   125                   * dropped when the EFI hits the AIL.
   126                   *
   127                   * If the transaction was not committed, the EFI is freed by the
   128                   * EFI item unlock handler on abort. Also, we have a new
   129                   * transaction so we should return committed=1 even though we're
   130                   * returning an error.
   131                   */
   132                  if (committed) {
   133                          xfs_efi_release(efi);
   134                          xfs_force_shutdown((*tp)->t_mountp,
   135                                  (error == -EFSCORRUPTED) ?
   136                                          SHUTDOWN_CORRUPT_INCORE :
   137                                          SHUTDOWN_META_IO_ERROR);
   138                  }
   139                  return error;
   140          }

regards,
dan carpenter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
