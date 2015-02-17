Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2F56A7F6B
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 19:49:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0E19F8F8039
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 17:49:41 -0800 (PST)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id FfyrnHTBoxwdgxHM (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2015 17:49:40 -0800 (PST)
Received: from epcpsbgr2.samsung.com
	(u142.gpu120.samsung.co.kr [203.254.230.142])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NJW003VP7QQIB00@mailout3.samsung.com> for
	xfs@oss.sgi.com; Tue, 17 Feb 2015 10:49:38 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
	<1424101680-3301-2-git-send-email-linkinjeon@gmail.com>
	<20150216235346.GD4251@dastard>
In-reply-to: <20150216235346.GD4251@dastard>
Subject: RE: [PATCH RESEND 1/12] fs: Add support FALLOC_FL_INSERT_RANGE for
	fallocate
Date: Tue, 17 Feb 2015 10:49:37 +0900
Message-id: <001301d04a53$fcd91310$f68b3930$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: 'Dave Chinner' <david@fromorbit.com>
Cc: linux-man@vger.kernel.org, 'Namjae Jeon' <linkinjeon@gmail.com>, tytso@mit.edu, linux-api@vger.kernel.org, bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mtk.manpages@gmail.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

> On Tue, Feb 17, 2015 at 12:47:48AM +0900, Namjae Jeon wrote:
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > FALLOC_FL_INSERT_RANGE command is the opposite command of
> > FALLOC_FL_COLLAPSE_RANGE that is needed for advertisers or someone who want to
> > add some data in the middle of file. FALLOC_FL_INSERT_RANGE will create space
> > for writing new data within a file after shifting extents to right as given
> > length. and this command also has same limitation as FALLOC_FL_COLLAPSE_RANGE,
> > that is block boundary and use ftruncate(2) for crosses EOF.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > Cc: Brian Foster<bfoster@redhat.com>
> > ---
> >  fs/open.c                   |    8 +++++++-
> >  include/uapi/linux/falloc.h |   17 +++++++++++++++++
> >  2 files changed, 24 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/open.c b/fs/open.c
> > index 813be03..762fb45 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -232,7 +232,8 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> >
> >  	/* Return error if mode is not supported */
> >  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> > -		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
> > +		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
> > +		     FALLOC_FL_INSERT_RANGE))
> >  		return -EOPNOTSUPP;
> 
> Can we create a FALLOC_FL_SUPPORTED_MASK define in falloc.h
> so that we only need to add new flags to the mask in rather than
> change this code every time we add a new flag?
Sure, I will do it. and share the patch with the others you gave me review points soon.

Thanks for review!
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
