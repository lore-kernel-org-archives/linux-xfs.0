Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9AE8429DF8
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 04:11:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27234AC002
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 02:11:31 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id vN0nBgRgX16vJ89g (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 May 2013 02:11:27 -0700 (PDT)
Date: Mon, 6 May 2013 12:11:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: xfs: add buffer types to directory and attribute buffers
Message-ID: <20130506091116.GA2129@elgon.mountain>
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
To: dchinner@redhat.com
Cc: xfs@oss.sgi.com

Hello Dave Chinner,

The patch d75afeb3d302: "xfs: add buffer types to directory and 
attribute buffers" from Apr 3, 2013, leads to the following Smatch warning:
"fs/xfs/xfs_log_recover.c:2042 xlog_recovery_validate_buf_type()
	 warn: always true condition '(magicda != 1480675917) =>  (0-u16max != 1480675917)'"

fs/xfs/xfs_log_recover.c
  2039          case XFS_BLFT_ATTR_RMT_BUF:
  2040                  if (!xfs_sb_version_hascrc(&mp->m_sb))
  2041                          break;
  2042                  if (magicda != XFS_ATTR3_RMT_MAGIC) {
                            ^^^^^^^
This is an unsigned short so it can never be equal to 0x5841524d.  Was
"magic32" intended here?

  2043                          xfs_warn(mp, "Bad attr remote magic!");
  2044                          ASSERT(0);
  2045                          break;
  2046                  }
  2047                  bp->b_ops = &xfs_attr3_rmt_buf_ops;
  2048                  break;

regards,
dan carpenter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
