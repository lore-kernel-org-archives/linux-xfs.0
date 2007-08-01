Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 31 Jul 2007 19:32:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l712WZbm030346
	for <xfs@oss.sgi.com>; Tue, 31 Jul 2007 19:32:37 -0700
Date: Wed, 01 Aug 2007 12:36:21 +1000
Subject: Re: RFC: log record CRC validation
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <20070725092445.GT12413810@sgi.com> <46A7226D.8080906@sgi.com> <46A8DF7E.4090006@agami.com> <20070726233129.GM12413810@sgi.com> <46A94963.7000103@agami.com> <20070727065930.GT12413810@sgi.com> <46AFD88E.9070403@agami.com> <20070801022418.GR31489@sgi.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.twcz6vvu3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20070801022418.GR31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Michael Nishimoto <miken@agami.com>
Cc: markgw@sgi.com, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, 01 Aug 2007 12:24:18 +1000, David Chinner <dgc@sgi.com> wrote:

> On Tue, Jul 31, 2007 at 05:49:18PM -0700, Michael Nishimoto wrote:
>
>> What are your plans for adding CRCs to other metadata objects?
>
> Other objects will require some on-disk format change, and that will
> require a feature bit to be set.
>
> Basically, we can add CRCs to individual inodes without a version bump
> as we have some empty space in the v2 inode core. That will make v2  
> inodes
> the default, but we already have a superblock bit for that and all  
> versions
> of linux support v2 inodes so there is no issue there. This will require
> userspace tool changes, though, because tools like repair will revert v2
> inodes back to v1 format if the are not using project id's or the link  
> count
> fits into 16 bits.....

No, repair does not revert v2 inodes back to v1. Currently, inodes
are created as v1 in the kernel and moved to v2 as required.

Barry.
