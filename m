Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMD16Ym016686
	for <linux-xfs@oss.sgi.com>; Mon, 22 Dec 2008 07:01:07 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78E5F1B9D4F9
	for <linux-xfs@oss.sgi.com>; Mon, 22 Dec 2008 05:01:05 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id tpmPQIzcAgjWTh1b for
	<linux-xfs@oss.sgi.com>; Mon, 22 Dec 2008 05:01:05 -0800 (PST)
Date: Mon, 22 Dec 2008 08:01:03 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFE] --reference option for setfattr
Message-ID: <20081222130103.GA12367@infradead.org>
References: <49101B02.60004@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49101B02.60004@redhat.com>
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
To: Ales Zelinka <azelinka@redhat.com>
Cc: linux-xfs@oss.sgi.com

On Tue, Nov 04, 2008 at 10:50:58AM +0100, Ales Zelinka wrote:
> currently when I want to copy all extended attributes from one file to  
> another, I have to use ugly command like this:
>
> getfattr --dump -m '-' /etc/samba/smb.conf |sed 's;file:  
> etc/samba/smb.conf;file: /tmp/smb.conf;'| setfattr --restore=-
>
> Would you please implement --reference=some_file option that will read  
> all extended attributes set on some_file and set them on pathname?
>
> The previous use case would then look like this:
>
> setfattr --reference=/etc/samba/smb.conf /tmp/smb.conf
>
> Other commands from file-attributes-manipulation familly already have  
> parameter like this (chmod, chown, chcon,...)

This feature seems useful to me, any chance you could try coming up with
a patch?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
