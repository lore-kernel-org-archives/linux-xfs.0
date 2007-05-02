Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 May 2007 02:48:16 -0700 (PDT)
Received: from ppsw-7.csi.cam.ac.uk (ppsw-7.csi.cam.ac.uk [131.111.8.137])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l429mCfB003811
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 02:48:14 -0700
In-Reply-To: <20070502091526.GW77450368@melbourne.sgi.com>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1177994346.3362.5.camel@entropy> <20070501142049.GG77450368@melbourne.sgi.com> <084192A9-D739-44F2-AD21-30BC30486F07@cam.ac.uk> <20070502091526.GW77450368@melbourne.sgi.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <1AFF1746-8313-4DC2-81D6-4271B5FB71A3@cam.ac.uk>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Wed, 2 May 2007 10:45:55 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Nicholas Miell <nmiell@comcast.net>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

On 2 May 2007, at 10:15, David Chinner wrote:
> On Tue, May 01, 2007 at 07:46:53PM +0100, Anton Altaparmakov wrote:
>> And all applications will run against a multitude of
>> kernels.  So version X of the application will run on kernel 2.4.*,
>> 2.6.*, a.b.*, etc...  For future expandability of the interface I
>> think it is important to have both compulsory and non-compulsory  
>> flags.
>
> Ah, so that's what you want - a mutable interface. i.e. versioning.
>
> So how does compusory flags help here?

A concrete example:

Let's say that the FIEMAP interface goes live as is without any flags  
at all and just defined bits for "these are optional and those are  
compulsory".

Then the next kernel adds support for optional flag HSM_READ and  
compulsory flag XATTR_READ.

FS that do not support XATTR_READ will return -ENOTSUP as they cannot  
return the wanted data.

FS that do not support HSM_READ will still return the correct data in  
majority of cases (except when the FS supports HSM and the data is  
actually OFFLINE which the application will need to be able to cope  
with anyway incase the FS failed to bring the file ONLINE even if it  
supports the HSM_READ flag so no added complexity for handling this  
case).

> What happens if a voluntary flag now becomes compulsory? Or vice  
> versa? How is the application supposed to deal with this dynamically?

Forgot to answer this bit:  This cannot happen.  There cannot be  
flags that move from compulsory to non-compulsory or anything stupid  
like that.  It would have to be a totally new flag otherwise it  
breaks backwards compatibility and hence this interface becomes  
useless crap.

> I suggested a version number for this right back at the start of
> this discussion and got told that we don't want versioned interfaces
> because we should make the effort to get it right the first time.
> I don't think this can be called "getting it right".

So all applications end up doing:

if (version X, do blah)
else if (version Y, do blob)
else if (version Z, do foo)
else if (version A, do bar)
else exit(1);

Every time a new version is added?  And abort for unknown versions?   
Now that is a great interface!  Not.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
