Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B48237CB1
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 22:42:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87B7F304043
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 20:42:29 -0700 (PDT)
Received: from mail-qg0-f41.google.com (mail-qg0-f41.google.com
	[209.85.192.41]) by cuda.sgi.com with ESMTP id whwFUYxqpRQt8AzZ
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 Jun 2016 20:42:27 -0700 (PDT)
Received: by mail-qg0-f41.google.com with SMTP id q32so14445703qgq.3
	for <xfs@oss.sgi.com>; Wed, 08 Jun 2016 20:42:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <00bbe658-a891-3771-ca1d-5661a8b6ab61@sandeen.net>
References: <CAAA5faG3Ls0Dh_bx=950db9BV01zoLfmubKbM0UYkWpS0y60BA@mail.gmail.com>
	<79c8e051-24a9-2e2b-553a-bcab17d03e83@sandeen.net>
	<20160607062717.GA30022@infradead.org>
	<c0b9776e-6917-13f2-1948-e7d51f72a909@monom.org>
	<CAAA5faEvt-vrvrkWC8-9Fys0WHN2TBQz7-Y-mtU8FaRHxUM6rw@mail.gmail.com>
	<48817b4c-26f4-5eb6-8a97-d8fa34fe7f6a@monom.org>
	<20160607134442.GA1803@infradead.org>
	<CAAA5faFWyPDienm2NbHkafZh-RvbjJp6f_zDq62z6rC1d1Vzyw@mail.gmail.com>
	<CAAA5faGXHJZPWkkxDM-kvHqh--hPhnD1Y8RuaaSmuzgiz=_LDg@mail.gmail.com>
	<CAAA5faEDdR_L6y9ShhUcermgvjtmzNCzwoYeENjx+8RUEMdwaA@mail.gmail.com>
	<20160609022238.GY26977@dastard>
	<CAAA5faGL_Nyu=jW2Vrgr_m7crhnB9BriWWzMAPODbiQATFhS=Q@mail.gmail.com>
	<00bbe658-a891-3771-ca1d-5661a8b6ab61@sandeen.net>
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Date: Wed, 8 Jun 2016 21:42:26 -0600
Message-ID: <CAAA5faH7RA=_WByj6uh4yVCLgwxkLh88CkrtTOa-qJqdyEDT-A@mail.gmail.com>
Subject: Re: crash in xfs in current
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
Cc: Christoph Hellwig <hch@infradead.org>, Daniel Wagner <wagi@monom.org>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Wed, Jun 8, 2016 at 8:56 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 6/8/16 9:53 PM, Reinoud Koornstra wrote:
>
>>> In your Linus git tree:
>>>
>>> $ git remote add xfsdev git://git.kernel.org/git/dgc/linux-xfs.git
>>> $ git remote update
>>> $ git checkout -b xfsdev-merge v4.6
>>> $ git merge xfsdev/xfs-for-linus-4.7-rc1
>>
>> Tried to do this:
>>
>> reinoud@router-dev:~/Downloads/kernel_current$  git remote add xfsdev
>> git://git.kernel.org/git/dgc/linux-xfs.git
>
> I think that should be:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

Ok That worked better indeed. :)

reinoud@router-dev:~/Downloads/kernel_current$ git remote add xfsdev
git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
reinoud@router-dev:~/Downloads/kernel_current$ git remote update
Fetching origin
Fetching xfsdev
remote: Counting objects: 139, done.
[SNIP]
reinoud@router-dev:~/Downloads/kernel_current$ git checkout -b xfsdev-merge v4.6
Checking out files: 100% (9437/9437), done.
Switched to a new branch 'xfsdev-merge'
reinoud@router-dev:~/Downloads/kernel_current$ git merge
xfsdev/xfs-for-linus-4.7-rc1
merge: xfsdev/xfs-for-linus-4.7-rc1 - not something we can merge
So i tried this:

reinoud@router-dev:~/Downloads/kernel_current$ git merge xfs-for-linus-4.7-rc1
Auto-merging fs/xfs/xfs_super.c
Auto-merging fs/xfs/xfs_pnfs.c
Auto-merging fs/xfs/xfs_mount.h
Auto-merging fs/xfs/xfs_mount.c
Auto-merging fs/xfs/xfs_file.c
Auto-merging fs/xfs/xfs_bmap_util.c
Auto-merging fs/xfs/xfs_aops.c
Auto-merging fs/xfs/libxfs/xfs_bmap.c
Auto-merging fs/namei.c
Merge made by the 'recursive' strategy.
The terminal did hang .... in 4.6
I killed the git operation and did it again and now it says it's up to date.

reinoud@router-dev:~/Downloads/kernel_current$ git merge xfs-for-linus-4.7-rc1
Already up-to-date.
reinoud@router-dev:~/Downloads/kernel_current$ git status
On branch xfsdev-merge

Is this correct, can I now build and test?

>
> -Eric
>
>> reinoud@router-dev:~/Downloads/kernel_current$  git remote update
>> Fetching origin
>> Fetching xfsdev
>> fatal: remote error: access denied or repository not exported:
>> /git/dgc/linux-xfs.git
>> error: Could not fetch xfsdev
>>
>> I don't think I have access to git.kernel.org in terms of pushing. :)
>> Or am I doing something else wrong.
>> Forgive the trivial question.
>>
>> Btw, I started in the most current linus git tree.... or should I git
>> 4.6.y and then do your suggestions?
>>
>> Thanks,
>>
>> Reinoud.
>>
>>>
>>> And that should give you the XFS changes for 4.7-rc1 in a vanilla 4.6
>>> tree. This merge is one of the things I test (i.e. send to my test
>>> machiens for a round of xfstests and other stress) before sending a
>>> pull request to Linus, so it should work just fine.
>>>
>>> Cheers,
>>>
>>> Dave.
>>> --
>>> Dave Chinner
>>> david@fromorbit.com
>>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
