Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1GC1wRX251058 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 06:01:58 -0600
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id QyObxGRlXGVH6Uhf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Feb 2012 04:01:56 -0800 (PST)
Date: Thu, 16 Feb 2012 13:01:42 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: Transactional XFS?
Message-ID: <20120216120142.GA18800@citd.de>
References: <CAFLt3phWcaQ4K3OPSVUkyN0BXqh+jQgQbeA59Oav23aOPLYMYw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFLt3phWcaQ4K3OPSVUkyN0BXqh+jQgQbeA59Oav23aOPLYMYw@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Grozdan <neutrino8@gmail.com>
Cc: xfs@oss.sgi.com

On 15.02.2012 20:15, Grozdan wrote:
> Hi,
> 
> I just finished watching the excellent speech of Dave Chinner at
> linux.conf.au and I must say I'm impressed by the recent improvements
> to XFS. Towards the end of the talk, Dave talked about upcoming
> improvements on Metadata reliability and other features. What I'm
> wondering about is if there are any plans in making XFS transactional
> (fully atomic) like it is the case with recent NTFS versions on
> Windows Vista and higher?

You could argue if it is NTFS doing the work at all.
I glanced over a document describing it, and as far as i remember the 
KTM-Component does all the work and stores the changes into a 
specialized database.
So effectivly you have a shim at the VFS-Layer that lets "others" see 
the old data while your application can see the new data and when you 
"commit", all the filesystem changes stored in the database are applied 
to the filesystem.

As far as i unterstand it you wouldn't necessarily need support for that 
in the filesystem itself, you could do it at the VFS level.

So one of the union/layered-"things" should be able to do that.
IOW, store all the changes necessary and "replay" the changes to the 
actual filesystem when doing the commit. (Or the opposite, depending if 
you expect a commit or rollback as the default operation at transaction 
end.)

Or BTRFS should be able to do that, when they implement snapshot at 
directory-level (AFAIR BTRFS currently supports snapshots at subvolume 
level, so if you use a subvolume you could already to that). You would 
snapshot the dir, do your work in the snapshot and switch the original 
dir with the snapshot on commit.
Altough i don't know if you can switch a mounted subvolume, or if it has 
to be umounted first. Having to do a umount might be problematic, 
depending on use-case.





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
