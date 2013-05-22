Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 243DB7CBF
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 11:48:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ECDD68F807A
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 09:48:55 -0700 (PDT)
Received: from mail-ie0-f179.google.com (mail-ie0-f179.google.com
	[209.85.223.179]) by cuda.sgi.com with ESMTP id
	WUJJtM1V9eA5wdgZ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 09:48:38 -0700 (PDT)
Received: by mail-ie0-f179.google.com with SMTP id c13so5772948ieb.10
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 09:48:37 -0700 (PDT)
Message-ID: <519CF6CE.8020901@gmail.com>
Date: Wed, 22 May 2013 12:48:14 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: generic/258 questions (mount issue)...
References: <519C14A1.8000009@gmail.com> <20130522012620.GA29466@dastard>
	<519C3596.7080109@gmail.com> <519CD1D9.8050904@sandeen.net>
	<519CEF04.7060503@gmail.com> <519CEFFB.1080209@sandeen.net>
In-Reply-To: <519CEFFB.1080209@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 05/22/2013 12:19 PM, Eric Sandeen wrote:
> On 5/22/13 11:15 AM, Michael L. Semon wrote:
>> On 05/22/2013 10:10 AM, Eric Sandeen wrote:
>>> On 5/21/13 10:03 PM, Michael L. Semon wrote:

>> One day, I would like to earn git-log fame by incorporating better 
>> support for JFS and especially NILFS2 into xfstests.  However, 
>> that's a topic for another day.  I know that I have uses for both 
>> filesystems, but that doesn't mean anybody else does.  Their 
>> mailing lists don't give much hint of user community or progress.
> 
> The generic tests hopefully work; if not, it should be a fairly
> simple fixup.  And you're free to add fs-specific tests :)
> 
> (I'm not sure if we fall back by default to mkfs.$FSTYP and fsck.$FSTYP;
> if so, it might just work)
> 
> -Eric

They work fine--JFS currently survives all of generic/* intact--but...

JFS: The syntax for a lot of things is very close to that of ReiserFS, 
ext3, and ext4 filesystems.  However, before just inserting "jfs" into 
the common/rc case switches, test results need to be audited for JFS.  
Additionally, I don't know if the current tests use external journals 
for non-XFS filesystems:  My first attempt stepped all over the XFS 
journal creation script, looked messy, and was probably buggy as well.

NILFS2: fsstress/fsx seems to slowly rip NILFS2 to bits, and I have 
to come up with a narrower test and report bugs to those guys.  
common/rc could be revised to better target filesystems with no 
fsck whatsoever, such as NILFS2 and F2FS.  I've been getting by with 
a simple `ln -s /bin/true /sbin/fsck.nilfs2`, and really, that is the 
best long-term solution from an administrative standpoint.

So you see how this might be an easy fix but still take up hours in 
debugging...

Thanks again!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
