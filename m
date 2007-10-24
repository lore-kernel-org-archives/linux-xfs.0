Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Oct 2007 00:38:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9O7cFYi027757
	for <xfs@oss.sgi.com>; Wed, 24 Oct 2007 00:38:17 -0700
Date: Wed, 24 Oct 2007 17:39:55 +1000
Subject: Re: [RFC 0/2] Case-insensitive filename lookup for XFS
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; charset=utf-8
MIME-Version: 1.0
References: <op.t0m36sn43jf8g2@pc-bnaujok.melbourne.sgi.com> <30F0B02B-9857-43E8-89C0-E9C85EF081A2@cam.ac.uk> <7858EE76-E860-41C3-8AFC-CE67DF210081@cam.ac.uk>
Content-Transfer-Encoding: 7bit
Message-ID: <op.t0ox8tfb3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <7858EE76-E860-41C3-8AFC-CE67DF210081@cam.ac.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>, linux-fsdevel@vger.kernel.org

Hi Anton,

On Tue, 23 Oct 2007 20:07:47 +1000, Anton Altaparmakov <aia21@cam.ac.uk> wrote:

> I forgot to say:  If you do what I did for NTFS you can also throw
> away your custom dentry operations that your patch adds as the dcache
> then only holds correctly cased names so you are fine to do case
> sensitive dcache lookups at all times.  Access via wrongly cased name
> will always go to ->lookup inode operation and that is fine because
> such lookups almost never happen because majority of users will either
> use a GUI in which case all names are always correctly cased as the
> names displayed in the GUI are obtained from a ->readdir and thus show
> the correct case or they will use the command line in which case they
> will be savvy enough to use tab-completion in which case the names are
> correct case, too.  Tab-completion does not work on wrongly cased
> names so you are very unlikely to ever get a wrongly cased name at all.
>
> And yes of course you can on purpose construct a test / benchmark
> where having to do the ->lookup each time will be really slow because
> you keep creating files and then accessing them by wrongly cased name
> on purpose (or whatever) but I would hope that you do not care about
> such artificial benchmarks that do not reflect any real-world loads...

I have been looking at ntfs_lookup() and seeing how it does its stuff.
It seems that is the best way to go.

One thing I have noticed is with two or more attempted case-insensitive
lookups that don't exist yet case match the same
(ie. ntfs_lookup_inode_by_name() fails with -ENOENT), d_add(dent, NULL)
is called, populating the dentry with effective duplicates.

Eg:
  # cat /mnt/foo/fileNOTexist
  # cat /mnt/foo/FILEnotEXIST

Will have two negative dentries, am I correct?

Regards,
Barry.
