Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Nov 2006 18:41:00 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAH2emaG020525
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 18:40:50 -0800
Date: Fri, 17 Nov 2006 13:39:46 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
Message-ID: <20061117023946.GN11034@melbourne.sgi.com>
References: <455CB54F.8080901@sandeen.net> <BB70F203E29C2D37A2F727C8@timothy-shimmins-power-mac-g5.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BB70F203E29C2D37A2F727C8@timothy-shimmins-power-mac-g5.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, Nov 17, 2006 at 11:08:40AM +1000, Timothy Shimmin wrote:
> Hi Eric,
> 
> 
> Well there is a bug in the sb endian translation code then or its setup.
> All the field accesses should be correct, no?

The problem is the size of the variable translated in xfs_xlatesb()
is the offset of the next field minus the offset of the current
field.

With the last filed of the structure, it ends up being the
size of the structure minus the offset of the field. On a 32 bit
machine, the structure is 4 bytes larger that the offset of
the feature2 field. On 64 bit machine, the strucutre is
8 bytes larger than the offset of the features2 field,
so it translates is as though it was a 64 bit field,
not a 32 bit field.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
