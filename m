Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CE78F7CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 05:35:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4F58AAC004
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 03:35:19 -0800 (PST)
Received: from mail-vk0-f47.google.com (mail-vk0-f47.google.com
	[209.85.213.47]) by cuda.sgi.com with ESMTP id 6pCnGH5CkTJ92BW9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Feb 2016 03:35:15 -0800 (PST)
Received: by mail-vk0-f47.google.com with SMTP id e185so104996753vkb.1
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 03:35:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56C1A788.9020008@gmail.com>
References: <56B770B6.7040803@gmail.com> <56B77262.7090107@gmail.com>
	<CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw@mail.gmail.com>
	<56C0F150.60008@gmail.com>
	<CAHc6FU49uRb11HhO655jimn_CzLrDyGHAB2iDAv92cftCCXkEA@mail.gmail.com>
	<56C1A788.9020008@gmail.com>
Date: Mon, 15 Feb 2016 12:35:14 +0100
Message-ID: <CAHc6FU69k2uRXjSSS+9K0cXzFs74DPsz6DDv8GN=hmh7RpPA-Q@mail.gmail.com>
Subject: Re: richacl(7) man page review comments
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, lkml <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Mon, Feb 15, 2016 at 11:25 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> You're right. I was confusing with xattr(7). So, I think it might
> make some sense to eventually move both of these into man-pages (for
> richacl(7), at least, it's probably worth delaying this for a bit),
> since  they're describing kernel-user-space interfaces.

Well, the actual user-space interface is xattrs in both cases.

> I can see counter-arguments too, such as these pages are closely
> related to the corresponding user-space libraries you maintain.
> What do you think?

I would keep the man-pages where they are right now, but I don't have
a strong preference.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
