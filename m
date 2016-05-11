Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 231387CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 13:54:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CD9D7304032
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 11:54:34 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ZsAzjv3DjgEDyeUh for <xfs@oss.sgi.com>;
	Wed, 11 May 2016 11:54:31 -0700 (PDT)
Subject: Re: [PATCH] xfs/133 134: filter redundant projid 0 quota report
References: <1462979156-7648-1-git-send-email-zlang@redhat.com>
	<e0126658-70f7-f8f9-d3bd-a47df2c6ce96@sandeen.net>
	<20160511173621.GC17859@dhcp12-143.nay.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <469fcded-5869-239c-8668-1b58a6b0eedd@sandeen.net>
Date: Wed, 11 May 2016 13:54:29 -0500
MIME-Version: 1.0
In-Reply-To: <20160511173621.GC17859@dhcp12-143.nay.redhat.com>
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
To: xfs@oss.sgi.com, fstests <fstests@vger.kernel.org>



On 5/11/16 12:36 PM, Zorro Lang wrote:
> On Wed, May 11, 2016 at 11:04:28AM -0500, Eric Sandeen wrote:
>> On 5/11/16 10:05 AM, Zorro Lang wrote:
>>> After GETNEXTQUOTA ioctl be supported, xfs_quota -c "report" always
>>> outputs one more quota info about default quota (as project ID 0).
>>> For fix this problem, xfsprogs has merged commit 3d607a1.
>>
>> This is only for project quota, right?  user & group quota always
>> reports id 0 / root, because it exists in the passwd and group files.
> 
> Yes, only for project quota. The truth is we decide to report project
> quota #0 always, so we can just add one line "#0 0 0 0 00 ...." into
> xfs/133 and xfs/134 golden output file simply.
> 
> But for history reason, we can't do that. Mostly old xfsprogs still
> report "(null) 0 0 0 00 ..."(if use GETNEXTQUOTA), or don't report
> project id #0 (if use old GETQUOTA).

Right, so filter that out? ;)

...

>> Why not just do it as an actual filter, i.e.:
>>
>>
>>
>> diff --git a/common/filter b/common/filter
>> index 1be377c..2012729 100644
>> --- a/common/filter
>> +++ b/common/filter
>> @@ -302,6 +302,13 @@ _filter_quota()
>>  	sed -e 'N;s/TEST_DEV\n/TEST_DEV/g'
>>  }
>>  
>> +_filter_project_quota()
>> +{
>> +	# Project ID 0 is always present on disk but was not reported
>> +	# until the GETNEXTQUOTA ioctl came into use.  Filter it out.
>> +	_filter_quota | grep -v "^\#0"
>> +}
> 
> I thought about this before I send this patch. But I don't know if it's
> necessary to add a new common function. I thought the one who write
> a case need to report project, who can decide how to deal with
> its project id #0 output.
> 
> Likes what I did in xfs/133. I named projid 0 to "root", then fileter
> project name root directly. If we add a function named _filter_project_quota,
> and we tell others it can filter project ID 0. But if someone named
> projid #0, this function become hard to understand.

yes, but that's a lot of manual fiddling for every test that does a report
of a project quota.  Most don't care at all about id 0.

If someone wants project ID 0 reported, just use _filter_quota instead
of _filter_project_quota.

If someone gives prjid 0 a name "foobarbaz" then it won't be filtered,
and I think that's fine, they were doing something quite intentional.
All the filter does is suppress the default output which is new to any
test reporting project quota.

> Likes xfs/299, it named projid #0 to "root", and add "root" quota output
> into golden image. That's another way to deal with this bug. Maybe better?

I really think that a single, common filter function for a common form
of output makes more sense than expecting each test to handle it on a
case-by-case basis.

-Eric

> Thanks,
> Zorro 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
