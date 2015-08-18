Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1F5FB7CBE
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 10:36:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 11FA2304043
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 08:36:50 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id N4hhIKUEhFZfHAux for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2015 08:36:48 -0700 (PDT)
Message-ID: <55D3510F.1060106@sandeen.net>
Date: Tue, 18 Aug 2015 10:36:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs.xfs: fix ftype-vs-crc option combination testing
References: <55C43FBA.1080408@sandeen.net> <20150818065341.GI714@dastard>
In-Reply-To: <20150818065341.GI714@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 8/18/15 1:53 AM, Dave Chinner wrote:
> On Thu, Aug 06, 2015 at 10:18:50PM -0700, Eric Sandeen wrote:
>> mkfs.xfs got weird along the way; today it has different outcomes
>> depending on the order of option specification:
>>
>> $ mkfs/mkfs.xfs -n ftype=1 -m crc=0 -dfile,name=fsfile,size=16g
>> cannot specify both crc and ftype
>> $ mkfs/mkfs.xfs -m crc=0 -n ftype=1 -dfile,name=fsfile,size=16g
>> <succeeds>
>>
>> Somehow the tests got written as being constrained on what options
>> are specified - and in what order! - vs actually testing for
>> incompatible feature sets.
>>
>> It's fine to specify both crc & ftype options, as long as it's an
>> allowed combination, so just test for the incompatible combination
>> (crc=1 and ftype=0) after all options have been processed.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Did you test this, Eric?

Yep...

> $  mkfs.xfs /dev/sdc
> cannot disable ftype with crcs enabled
> Usage: mkfs.xfs
> /* blocksize */         [-b log=n|size=num]
> .....

God, but not with defaults!  I tested w/ all combinations of ftype/crc specified.  :(

...

> So we enable crcs by default and do not enable dirftype/nftype by
> default, and so by default mkfs now fails. I'll fix it to always
> default to ftype=1 for both v4 and v5 filesystems as there is no go
> reason not to enable it.

Hell.  Sorry about that.  Thanks for catching ...

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
