Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B008A7FBD
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 02:53:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A2EBF304032
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 00:53:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id M7Pg3Z2FC1gpRKMy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 00:53:55 -0700 (PDT)
Date: Tue, 6 May 2014 00:53:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] common: use a relative path to fsstress
Message-ID: <20140506075352.GE21910@infradead.org>
References: <20140504104510.GA9510@infradead.org>
	<20140504214913.GP26353@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140504214913.GP26353@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, May 05, 2014 at 07:49:13AM +1000, Dave Chinner wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > --- a/common/config
> > +++ b/common/config
> > @@ -134,7 +134,7 @@ export MOUNT_PROG="`set_prog_path mount`"
> >  export UMOUNT_PROG="`set_prog_path umount`"
> >  [ "$UMOUNT_PROG" = "" ] && _fatal "umount not found"
> >  
> > -export FSSTRESS_PROG="`set_prog_path fsstress $PWD/ltp/fsstress`"
> > +export FSSTRESS_PROG="./ltp/fsstress"
> 
> Why remove the set_prog_path call? i.e. this should work:
> 
> +export FSSTRESS_PROG="`set_prog_path fsstress ./ltp/fsstress`"
> 
> Otherwise, a comment explaining why set_prog_path is not used just
> for this binary would be appropriate....

set_prog_path is only useful for tools found in $PATH, and except for
fsstress we never use it for anything that we specify path to, so
I don't really see the need for a comment here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
