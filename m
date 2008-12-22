Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMDm1ls021721
	for <linux-xfs@oss.sgi.com>; Mon, 22 Dec 2008 07:48:02 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36FED3ECF2
	for <linux-xfs@oss.sgi.com>; Mon, 22 Dec 2008 05:47:58 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id KYTQrXFKv7oAdLQ3 for <linux-xfs@oss.sgi.com>;
	Mon, 22 Dec 2008 05:47:58 -0800 (PST)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [RFE] --reference option for setfattr
Date: Mon, 22 Dec 2008 14:47:54 +0100
References: <49101B02.60004@redhat.com> <20081222130103.GA12367@infradead.org>
In-Reply-To: <20081222130103.GA12367@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812221447.54325.agruen@suse.de>
Reply-To: acl-devel@bestbits.at
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@oss.sgi.com, acl-devel@bestbits.at, Ales Zelinka <azelinka@redhat.com>

On Monday, 22 December 2008 14:01:03 Christoph Hellwig wrote:
> On Tue, Nov 04, 2008 at 10:50:58AM +0100, Ales Zelinka wrote:
> > currently when I want to copy all extended attributes from one file to
> > another, I have to use ugly command like this:
> >
> > getfattr --dump -m '-' /etc/samba/smb.conf |sed 's;file:
> > etc/samba/smb.conf;file: /tmp/smb.conf;'| setfattr --restore=-
> >
> > Would you please implement --reference=some_file option that will read
> > all extended attributes set on some_file and set them on pathname?
> >
> > The previous use case would then look like this:
> >
> > setfattr --reference=/etc/samba/smb.conf /tmp/smb.conf
> >
> > Other commands from file-attributes-manipulation familly already have
> > parameter like this (chmod, chown, chcon,...)
>
> This feature seems useful to me, any chance you could try coming up with
> a patch?

getfattr/setfattr are modeled similar to getfacl/setfacl, and with those two 
tools you can do this (-b stands for --remove-all):

	getfacl /etc/samba/smb.conf | setfacl -b -M - /tmp/smb.conf

Would it make sense to implement this in setfattr in a similar way?
A -b option would be handy in this context as well, of course.

But maybe --reference is more convenient sometimes, and so it should be added 
in any case?

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
