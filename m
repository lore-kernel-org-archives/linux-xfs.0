Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 May 2007 01:24:31 -0700 (PDT)
Received: from ppsw-2.csi.cam.ac.uk (ppsw-2.csi.cam.ac.uk [131.111.8.132])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l438OPfB031233
	for <xfs@oss.sgi.com>; Thu, 3 May 2007 01:24:27 -0700
In-Reply-To: <20070503074909.GA6220@schatzie.adilger.int>
References: <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1177994346.3362.5.camel@entropy> <20070501142049.GG77450368@melbourne.sgi.com> <084192A9-D739-44F2-AD21-30BC30486F07@cam.ac.uk> <20070502091526.GW77450368@melbourne.sgi.com> <2604946E-CF10-426F-9720-DDABD10C8E0D@cam.ac.uk> <20070502105749.GY77450368@melbourne.sgi.com> <20070503074909.GA6220@schatzie.adilger.int>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <13539C2E-16DA-4F86-9CBB-D16050EDDC44@cam.ac.uk>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Thu, 3 May 2007 09:23:33 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Dilger <adilger@clusterfs.com>
Cc: David Chinner <dgc@sgi.com>, Nicholas Miell <nmiell@comcast.net>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org


On 3 May 2007, at 08:49, Andreas Dilger wrote:

> On May 02, 2007  20:57 +1000, David Chinner wrote:
>> On Wed, May 02, 2007 at 10:36:12AM +0100, Anton Altaparmakov wrote:
>>> HSM_READ is definitely _NOT_ required because all
>>> it means is "if the file is OFFLINE, bring it ONLINE and then return
>>> the extent map".
>>
>> You've got the definition of HSM_READ wrong. If the flag is *not*
>> set, then we bring everything back online and return the full extent
>> map.
>>
>> Specifying the flag indicates that we do *not* want the offline
>> extents brought back online.  i.e. it is a HSM or a datamover
>> (e.g. backup program) that is querying the extents and we want to
>> known *exactly* what the current state of the file is right now.
>>
>> So, if the HSM_READ flag is set, then the application is
>> expecting the filesytem to be part of a HSM. Hence if it's not,
>> it should return an error because somebody has done something wrong.
>
> In my original proposal I specifically pointed out that the
> FIEMAP_FLAG_HSM_READ has the OPPOSITE behaviour as the  
> XFS_IOC_GETBMAPX
> BMV_IF_NO_DMAPI_READ flag.  Data is retrieved from HSM only if the
> HSM_READ flag is set.  That's why the flag is called "HSM_READ"  
> instead
> of "HSM_NO_READ".

Cool.  I did not misunderstand after all then. (-:

> The reason is that it seems bad if the default behaviour for calling
> ioctl(FIEMAP) would be to force retrieval of data from HSM, and  
> this is
> only disabled by specifying a flag.  It makes a lot more sense to just
> leave the data as it is and return the extent mapping by default (i.e.
> this is the principle of least surprise).  It would probably be  
> equally
> surprising and undesirable if the default behaviour was to force all
> data out to HSM.
>
> For that matter, I'm also beginning to wonder if the FLAG_HSM_READ  
> should
> even be a part of this interface?  I have no problem with returning a
> flag that reports if the data is migrated to HSM and whether it is  
> UNMAPPED.
>
> Having FIEMAP force the retrieval of data from HSM strikes me as  
> something
> that should be a part of a separate HSM interface, which also needs  
> to be
> able to do things like push specific files or parts thereof out to  
> HSM,
> set the aging policy, and return information like "where does the HSM
> file live" and "how many copies are there".

That would seem sensible to me also.  Just like David argued that  
causing the data to be in a fixed location should be a separate  
interface rather than part of FIEMAP so by analogy the same should  
apply to touching HSM.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
