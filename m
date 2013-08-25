Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 93C0D7CBE
	for <xfs@oss.sgi.com>; Sun, 25 Aug 2013 00:18:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11377AC001
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 22:18:48 -0700 (PDT)
Received: from mail-yh0-f43.google.com (mail-yh0-f43.google.com
	[209.85.213.43]) by cuda.sgi.com with ESMTP id COzgz2V2Uq5nOvZz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 24 Aug 2013 22:18:46 -0700 (PDT)
Received: by mail-yh0-f43.google.com with SMTP id z20so559048yhz.2
	for <xfs@oss.sgi.com>; Sat, 24 Aug 2013 22:18:45 -0700 (PDT)
Message-ID: <521993AA.7010301@gmail.com>
Date: Sun, 25 Aug 2013 01:18:34 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 51/50] xfs: add xfs sb v4 support for dirent filetype field
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<20130819201940.516942026@sgi.com>
	<5212AA1D.3000809@sandeen.net> <52137D3D.8060205@sgi.com>
	<20130821000624.GO6023@dastard> <20130821170336.GJ5262@sgi.com>
	<20130822020226.GR6023@dastard> <20130822161456.GB23510@sgi.com>
	<20130822181910.GP5262@sgi.com>
In-Reply-To: <20130822181910.GP5262@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 08/22/2013 02:19 PM, Ben Myers wrote:
> Gents,
> 
> On Thu, Aug 22, 2013 at 11:14:56AM -0500, Geoffrey Wehrman wrote:
>> On Thu, Aug 22, 2013 at 12:02:26PM +1000, Dave Chinner wrote:
>> | I'm very, very, very unhappy about how this situation is unfolding.
>>
>> As am I.
> 
> Mark provided some mkfs code to test the v4 feature bit with, and it
> worked fine for me.
> 
> Given that we are protected by a feature bit, I feel that pulling in the
> v4 feature is considerably less risky than what we did in 3.10, with
> Dave still cleaning up his mess in -rc6, so go ahead and call me
> reckless:  I've pulled in both v4 and v5 versions of this code.
> 
> Mark, please post your mkfs code ASAP, even though Dave hasn't reposted
> his userspace series yet.
> 
> Everybody gets his code in and nobody is happy.
> 
> -Ben

Mark's v4 dirent patches seem to work on 32-bit x86.  I happen to agree 
100% with Dave on this issue.  However, lacking a dirent test and 
xfs_db skills, I threw everything else and the kitchen sink at 
v4-dirent XFS and did not find any evidence to back up Dave's argument. 
So I'll tip my cap to Mark for his insight on the matter, hoping that 
his testing skills are fine as always.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
