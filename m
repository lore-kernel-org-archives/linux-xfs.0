Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8AD517F50
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 14:45:49 -0500 (CDT)
Message-ID: <51A65AE8.5010500@sgi.com>
Date: Wed, 29 May 2013 14:45:44 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add missing colon in _filter_ln
References: <1369842106-9869-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1369842106-9869-1-git-send-email-eguan@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On 05/29/2013 10:41 AM, Eryu Guan wrote:
> On distros with older coreutils(eg. RHEL5) generic/294 fails like
>
>      -ln: creating symbolic link `SCRATCH_MNT/294.test/testlink': File exists
>      +ln: creating symbolic link `SCRATCH_MNT/294.test/testlink'File exists
>
> _filter_ln ate the ": ". xfs/103 has similar issue. Add ": " back.
>
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Thanks for the patch, it has been committed:

commit 3f09dca681eb0cdd850abbcdb4d6997a0890b09a
Author: Eryu Guan <eguan@redhat.com>
Date:   Wed May 29 14:42:09 2013 -0500

     xfstests: add missing colon in _filter_ln

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
