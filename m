Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Nov 2007 21:09:59 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAK59pVY002621
	for <linux-xfs@oss.sgi.com>; Mon, 19 Nov 2007 21:09:55 -0800
Message-ID: <47426C70.3070704@sgi.com>
Date: Tue, 20 Nov 2007 16:11:12 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: acl and attr: Fix path walking code
References: <200710281858.24428.agruen@suse.de> <4733F301.9020706@sgi.com> <200711102152.05619.agruen@suse.de> <473A82E6.50709@sgi.com>
In-Reply-To: <473A82E6.50709@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-xfs@oss.sgi.com, Gerald Bringhurst <gbringhurst@novell.com>, Brandon Philips <bphilips@suse.de>

> 
> 
>  > On Friday 09 November 2007 08:39:56 Timothy Shimmin wrote:
>  >> > You mention -L/-P is like chown.
>  >> > However, -P for getattr isn't about not walking symlinks
>  >> > to directories,
>  >> > it's about skipping symlinks altogether, right?
>  >
>  > Hmm, -L and -P define which files and directories are visited, and -h 
> defines
>  > whether we are looking at symlinks or the files they point to. The two
>  > concepts are orthogonal. -P is not about skipping symlinks, only 
> about not
>  > recursing into them.
>  >
> Oh okay.
> There is the concept of following the symlink for traversal versus
> following the symlink to get the EA on.
> 
> So with -L should it just follow the symlink or look at the symlink first
> and then follow it?
> And will -h modify this behavior?
> I'm still confused about the 1st difference in 062 output.
> 
> I wonder if the man pages can be clarified in this area :)
> 
> --Tim
> 

Okay, looked at the code.

---

no -h => stat, getxattr, listxattr
-h    => lstat, lgetxattr, llistxattr

-P => skip symlinks (as soon as see them, then return from place in walk)

-L => process symlink and then opendir on symlink (hence follow/traverse it)

default => -L for argument (depth==1) and -P for subdirs (depth>1)

----

This was different than my intuition.
I am happy with -h.
For -P, I was expecting it to process symlink but not follow/traverse it,
I wouldn't think it should just skip them altogether (I realise the
man page says that).

For -L, I wasn't sure if it should process it first and then traverse
or simply just traverse.

So were these your intentions?
If so, the code seems to follow them but it would be nicer to
have more explanation in the man page.

--Tim
