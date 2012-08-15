Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7FHN8fW165092 for <xfs@oss.sgi.com>; Wed, 15 Aug 2012 12:23:08 -0500
Message-ID: <502BDAF5.8040100@sgi.com>
Date: Wed, 15 Aug 2012 12:23:01 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC] [PATCH 0/18] xfstests: move tests out of top level
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
	<20120814213929.GN2877@dastard>
In-Reply-To: <20120814213929.GN2877@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/14/12 16:39, Dave Chinner wrote:
> Ping?
>
> On Thu, Jul 26, 2012 at 07:27:54PM +1000, Dave Chinner wrote:
>> Alt-Subject: Games with Sed, Grep and Awk.
>>
>> This series is based on top of the large filesystem test series.
>>
>> This moves all the tests into a ./tests subdirectory, and sorts them into
>> classes of related tests. Those are:
>>
>> 	tests/generic:	valid for all filesystems
>> 	tests/shared:	valid for a limited number of filesystems
>> 	tests/xfs:	xfs specific tests
>> 	tests/btrfs	btrfs specific tests
>> 	tests/ext4	ext4 specific tests
>> 	tests/udf	udf specific tests
>>
>> Each directory has it's own group file to determine what groups the
>> tests are associated with. Tests are run in exactly the same was as
>> before, but when trying to run individual tests you need to specify
>> the class as well. e.g. the old way:
>>
>> # ./check 001
>>
>> The new way:
>>
>> # ./check generic/001

I applied the series and started a closer look. I like what you have done.

As far as RFC, the only concern that I have heard so far is the desire 
to see benchmarking in the test suite.

--Mark.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
