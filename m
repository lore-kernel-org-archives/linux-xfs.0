Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A8167F37
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 12:08:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 163E48F8049
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 10:08:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JTa5neMU4wgQpwlD for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 10:08:20 -0700 (PDT)
Message-ID: <519CFB84.1030207@sandeen.net>
Date: Wed, 22 May 2013 12:08:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: generic/258 questions (mount issue)...
References: <519C14A1.8000009@gmail.com> <20130522012620.GA29466@dastard>
	<519C3596.7080109@gmail.com> <519CD1D9.8050904@sandeen.net>
	<519CEF04.7060503@gmail.com> <519CEFFB.1080209@sandeen.net>
	<519CF6CE.8020901@gmail.com>
In-Reply-To: <519CF6CE.8020901@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On 5/22/13 11:48 AM, Michael L. Semon wrote:
> On 05/22/2013 12:19 PM, Eric Sandeen wrote:
>> On 5/22/13 11:15 AM, Michael L. Semon wrote:
>>> On 05/22/2013 10:10 AM, Eric Sandeen wrote:
>>>> On 5/21/13 10:03 PM, Michael L. Semon wrote:
> 
>>> One day, I would like to earn git-log fame by incorporating better 
>>> support for JFS and especially NILFS2 into xfstests.  However, 
>>> that's a topic for another day.  I know that I have uses for both 
>>> filesystems, but that doesn't mean anybody else does.  Their 
>>> mailing lists don't give much hint of user community or progress.
>>
>> The generic tests hopefully work; if not, it should be a fairly
>> simple fixup.  And you're free to add fs-specific tests :)
>>
>> (I'm not sure if we fall back by default to mkfs.$FSTYP and fsck.$FSTYP;
>> if so, it might just work)
>>
>> -Eric
> 
> They work fine--JFS currently survives all of generic/* intact--but...
> 
> JFS: The syntax for a lot of things is very close to that of ReiserFS, 
> ext3, and ext4 filesystems.  However, before just inserting "jfs" into 
> the common/rc case switches, test results need to be audited for JFS.  
> Additionally, I don't know if the current tests use external journals 
> for non-XFS filesystems:  My first attempt stepped all over the XFS 
> journal creation script, looked messy, and was probably buggy as well.

xfs doesn't use external journal by default, it needs to have an extra
couple env. vars set (I think README covers this)

To test JFS that way it'd need more tweaking I suppose.  It could
be done, certainly.

> NILFS2: fsstress/fsx seems to slowly rip NILFS2 to bits, and I have 
> to come up with a narrower test and report bugs to those guys.

:)  not too surprising.  (first time I looked at ecryptfs vs.
fsx, fsx won the fight in about 3 ops.  Much better now.)

I'd just use fsx directly to narrow down failures to the smallest
set of operations.

> common/rc could be revised to better target filesystems with no 
> fsck whatsoever, such as NILFS2 and F2FS.  I've been getting by with 
> a simple `ln -s /bin/true /sbin/fsck.nilfs2`, and really, that is the 
> best long-term solution from an administrative standpoint.

Yeah I'd suggest that maybe nilfs2-utils should just ship something like that.

> So you see how this might be an easy fix but still take up hours in 
> debugging...

Yup.

-Eric

> Thanks again!
> 
> Michael
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
