Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5417D7F50
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 13:31:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E494EAC001
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 11:31:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id W94hVDhlD7tzGQH6 for <xfs@oss.sgi.com>;
	Thu, 02 May 2013 11:31:27 -0700 (PDT)
Message-ID: <5182B0FE.4030301@sandeen.net>
Date: Thu, 02 May 2013 13:31:26 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix internal _xfs_check to handle logdev etc
References: <51827DDF.4050708@redhat.com>
	<1367509132.4098.86.camel@chandra-dt.ibm.com>
	<51828F84.3040508@sandeen.net>
	<1367516658.4098.87.camel@chandra-dt.ibm.com>
In-Reply-To: <1367516658.4098.87.camel@chandra-dt.ibm.com>
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
To: sekharan@us.ibm.com
Cc: Eric Sandeen <sandeen@redhat.com>, "Michael L. Semon" <mlsemon35@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On 5/2/13 12:44 PM, Chandra Seetharaman wrote:
> On Thu, 2013-05-02 at 11:08 -0500, Eric Sandeen wrote:
>> On 5/2/13 10:38 AM, Chandra Seetharaman wrote:
>>> On Thu, 2013-05-02 at 09:53 -0500, Eric Sandeen wrote:
>>>> Pull all of the old xfs_check script into common/rc:_xfs_check()
>>>> so that it properly handles all options, including external log
>>>> devices.
>>>
>>> I see changes only related to USAGE. iiuc, log devices are handled
>>> properly by current code.
>>
>> also:
>>
>>>> +    set -- extra $@
>>>> +    shift $OPTIND
>>
>> have you *tested* log devices w/ your original code?  It failed for
>> Michael and for myself, so...  ;)
>>
>> -Eric
> 
> yikes. sorry :(

It's ok - I reviewed it, but I didn't test it.  ;)  It happens.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
