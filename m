Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 02D2A7F3F
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 13:34:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 774ADAC002
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 11:34:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id menFYIV8kU4rpNl3 for <xfs@oss.sgi.com>;
	Thu, 11 Jul 2013 11:34:38 -0700 (PDT)
Message-ID: <51DEFABC.8020104@sandeen.net>
Date: Thu, 11 Jul 2013 13:34:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: generic/313, test sgid inheritance on subdirs
References: <51A68175.9020202@redhat.com> <51A7B03E.2080909@sandeen.net>
	<20130612192320.GA12955@andromeda.usersys.redhat.com>
	<20130708215151.GK20932@sgi.com>
	<20130711175315.GB10711@andromeda.usersys.redhat.com>
	<20130711182829.GC10711@andromeda.usersys.redhat.com>
In-Reply-To: <20130711182829.GC10711@andromeda.usersys.redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Ben Myers <bpm@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On 7/11/13 1:28 PM, Carlos Maiolino wrote:
>>>
>>> generic/313      - output mismatch (see /root/xfstests/results/generic/313.out.bad)
>>>     --- tests/generic/313.out   2013-07-08 16:27:41.787710646 -0500
>>>     +++ /root/xfstests/results/generic/313.out.bad      2013-07-08 16:47:46.052683735 -0500
>>>     @@ -1,3 +1,3 @@
>>>      QA output created by 313
>>>     -drwxr-sr-x. TEST_DIR/313-dir/subdir
>>>     +drwxr-sr-x TEST_DIR/313-dir/subdir
>>>      drwxrwsr-x+ TEST_DIR/313-dir/subdir2
>>>      ...
>>>      (Run 'diff -u tests/generic/313.out /root/xfstests/results/generic/313.out.bad' to see the entire diff)
>>>
>>> Looks like there could be a problem with ls?  Have you seen that?
>>>
>>> Thanks,
>>> Ben
>>>
>> Actually I don't think this is a problem, but the way newer `ls` versions are
>> displaying the object permissions (the 'dot' at the end of the permissions,
>> indicating there are no extra attributes).
>>
>> I'm going to take a look on what's going on, but I still believe it's just a
>> matter of add the 'dot' to the xfstests correct output.
>>
>> I had this same problem when testing my patch and needed to fix it locally, but
>> missed to warn you guys, my apologies
>>
> Just a matter of information:
> 
> From coreutils:
> 
> commit b3677e5e383103bf1764b2c8a9329b1c17934b24
> Author: Jim Meyering <meyering@redhat.com>
> Date:   Wed Apr 2 22:26:45 2008 +0200
> 
>     ls: use '.' (not +) as SELinux-only alt. access flag in ls -l output
> 
> 
> 
> So, this test is selinux dependent, it will provide different outputs whether
> the system has selinux enabled or not.
> 
> Since the test itself creates their own directories, checking if the selinux is
> enabled or not and checking the proper output depending on selinux activity
> should avoid false positives on this test. I.e. if the selinux is enabled, the
> `ls -l` output will print the 'dot' at the end of the permissions, otherwise,
> nothing will be printed and Eric's test will pass without problem.

Hm, I thought we always mounted with a global selinux context, and therefore
wouldn't get these differences (i.e. no on-disk selinux attrs should be created)

> I think this is something worth to mention on xfstests README or some other
> documentation, mainly because any kind of test like this, but done with the
> TEST_DEV might be even worst since we don't recreate the filesystem while using
> TEST_DEV, so, objects there can be created with selinux attrs or not (if created
> when selinux is disabled) and have the attributes added later.

It'd be better to just add a filter if we need it.

But I'd like to know why we need it, I thought the global context made these
problems go away...

Guess I'll go look...

-Eric

> I'm probably being too paranoid here talking about the TEST_DEV, but, I thought
> it was worth to mention.
> 
> Cheers.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
