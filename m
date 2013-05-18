Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 712917F3F
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 02:43:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D67F5AC001
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 00:43:17 -0700 (PDT)
Received: from mail-ie0-f173.google.com (mail-ie0-f173.google.com
	[209.85.223.173]) by cuda.sgi.com with ESMTP id
	m8ndXA0jgQpdPP9J (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 18 May 2013 00:43:13 -0700 (PDT)
Received: by mail-ie0-f173.google.com with SMTP id k5so10995449iea.18
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 00:43:13 -0700 (PDT)
Message-ID: <519730FD.7050200@gmail.com>
Date: Sat, 18 May 2013 03:42:53 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/30] xfsprogs: Initial CRC support
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
	<51969917.2080209@gmail.com> <20130518032507.GA6495@dastard>
	<51971457.7060903@gmail.com> <20130518062718.GD6495@dastard>
In-Reply-To: <20130518062718.GD6495@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 05/18/2013 02:27 AM, Dave Chinner wrote:
> On Sat, May 18, 2013 at 01:40:39AM -0400, Michael L. Semon wrote:
>> On 05/17/2013 11:25 PM, Dave Chinner wrote:
>>> On Fri, May 17, 2013 at 04:54:47PM -0400, Michael L. Semon wrote:
>>>> On 05/17/2013 07:12 AM, Dave Chinner wrote:

> Being able to add and remove patches and reorder them easily is
> exactly why I use guilt. The raw git workflow is, well, less than
> optimal IMO.
>
>> The trick is to remember which patches to apply, so I might have a
>> directory that has five great patches and one that no longer
>> applies.
>>
>>> The worst step for me is, by far, the git-am step. Resolving patch
>>> conflicts is painful because you have to manually apply the patch,
>>> then remember to git add all the files modified by the patch, etc.
>>
>> I don't know how to use git to properly back out a patch that was
>> made at some time in the past.  Disaster management in particular
>> has left me to backup at strategic points.  On these older PCs,
>> restore operations can be much faster than git recovery attempts.
>
> So, once I've have a patch series imported into git as a guilt
> stack, it's managed as a series of patches rather than as individual
> patches or commits. The order is kept in a series file. So, updating
> the underlying release for a specific patch set is effectively:
>
> $ guilt checkout working	# go to base tree branch
> $ guilt pop -a			# remove all patches in the branch
> $ git reset --hard v3.10-rc1	# reset branch to known clean state
> $ git remote update
> $ git merge origin/master	# linus tree
> $ git merge xfs-oss/master	# xfs tree
> $ guilt push -a			# push all local patches back into branch
>
> At this point I have an up-to-date linus + xfs + local patches
> branch.
>
> Say now I want add a new patchset in from the list. I save it as an
> mbox file "saved-patches". Then I create a new branch from the xfs
> tree so I know that it will apply cleanly:
>
> $ git checkout -b imports xfs-oss/master
> 				# create a new branch from the xfs tree
> $ git am saved-patches
> .....
>
> Now all patches are applied to the imports branch. Get all the
> commit ids, switch back to the working branch, and import them into
> guilt to track them as patches:
>
> $ git log --oneline -n <number of patches in the seriesi + 2>
> yyyy last commit
> ....
> xxxx commit prior to first in new series
> $ git checkout working
> $ guilt import-commit xxxx..yyyy # import the commits onto the tail
> 				 # of the current patch series
> $ guilt push -a			 # apply the patchset to the current branch
> $ git branch -D imports		 # remove the temp import branch.
>
> At this point, all the patches in the series you just pulled down
> from the list are applied to your tree. You can now push and pop
> them out of the tree, reorder them, etc as though you are just
> managing a series of patches....
>
> If any of the patches in the inew series fail to apply, then guilt
> won't apply it. If you force apply it, guilt outputs the result of
> applying the patch, same as if you ran patch. The difference is that
> for all the modified files and  the files that need to be editted to
> fix conflicts, you don't need to git add them. just "guilt refresh"
> and you're ready to push the next patch in the series onto the
> stack...

Ah, excellent explanation!  guilt sounds awesome.  Not finding anything 
that looked like an official site for guilt that worked, I grabbed the 
guilt source from the wheezy section at packages.debian.org.  At the 
next opportunity, I will learn it, live it, love it.

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
