Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0354F7F3F
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 13:53:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D32F8304051
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 11:53:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id hOCQv1GXD1OpcDgt for <xfs@oss.sgi.com>;
	Thu, 11 Jul 2013 11:53:38 -0700 (PDT)
Message-ID: <51DEFF30.10104@sandeen.net>
Date: Thu, 11 Jul 2013 13:53:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: generic/313, test sgid inheritance on subdirs
References: <51A68175.9020202@redhat.com> <51A7B03E.2080909@sandeen.net>
	<20130612192320.GA12955@andromeda.usersys.redhat.com>
	<20130708215151.GK20932@sgi.com>
	<20130711175315.GB10711@andromeda.usersys.redhat.com>
	<20130711182829.GC10711@andromeda.usersys.redhat.com>
	<51DEFABC.8020104@sandeen.net>
In-Reply-To: <51DEFABC.8020104@sandeen.net>
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

On 7/11/13 1:34 PM, Eric Sandeen wrote:
> On 7/11/13 1:28 PM, Carlos Maiolino wrote:

...

>> Just a matter of information:
>>
>> From coreutils:
>>
>> commit b3677e5e383103bf1764b2c8a9329b1c17934b24
>> Author: Jim Meyering <meyering@redhat.com>
>> Date:   Wed Apr 2 22:26:45 2008 +0200
>>
>>     ls: use '.' (not +) as SELinux-only alt. access flag in ls -l output
>>
>>
>>
>> So, this test is selinux dependent, it will provide different outputs whether
>> the system has selinux enabled or not.
>>
>> Since the test itself creates their own directories, checking if the selinux is
>> enabled or not and checking the proper output depending on selinux activity
>> should avoid false positives on this test. I.e. if the selinux is enabled, the
>> `ls -l` output will print the 'dot' at the end of the permissions, otherwise,
>> nothing will be printed and Eric's test will pass without problem.
> 
> Hm, I thought we always mounted with a global selinux context, and therefore
> wouldn't get these differences (i.e. no on-disk selinux attrs should be created)


Ok, somehow it really is mounted w/o the context when the test executes.
I'm not sure why yet, but fixing that *should* fix the problem, I think.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
