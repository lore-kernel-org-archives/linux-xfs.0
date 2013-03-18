Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E57E07F8D
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 12:35:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CAB9F8F8035
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 10:35:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aG7ilyQixTvxjylR for
	<xfs@oss.sgi.com>; Mon, 18 Mar 2013 10:35:06 -0700 (PDT)
Message-ID: <51475043.4010505@redhat.com>
Date: Mon, 18 Mar 2013 12:34:59 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: possible dev branch regression - xfstest 285/1k
References: <20130315222818.GA16100@wallace> <20130316150923.GA18589@gmail.com>
	<20130317030648.GA14225@thunk.org>
	<51473C8B.5070509@redhat.com> <20130318170927.GA5639@thunk.org>
In-Reply-To: <20130318170927.GA5639@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: xfs-oss <xfs@oss.sgi.com>, linux-ext4@vger.kernel.org, Eric Whitney <enwlinux@gmail.com>

On 3/18/13 12:09 PM, Theodore Ts'o wrote:
> On Mon, Mar 18, 2013 at 11:10:51AM -0500, Eric Sandeen wrote:

<previous discussion thread about test 285 SEEK_HOLE test
breaking on ext4 due to change in opportunistic hole-filling
behavior and how to make it work again on ext4, and mention
of sysctl which makes it pass>

>> The test could do this too, right?
>>
>> _need_to_be_root
>>
>> and:
>>
>> if [ "$FSTYP" == "ext4" ]; then
>> 	ORIG_ZEROOUT_KB=`cat /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_kb`
>> 	echo 0 > /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_kb
>> fi
>>
>> and put it back to default in _cleanup:
>>
>> 	echo $ORIG_ZEROOUT_KB > /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_kb
>>
>> That way we'd be testing seek hole correctness w/o being subject to
>> the vagaries in allocator behavior.
> 
> Yeah, the question is whether it would be more acceptable to put
> ext4-specific hacks like this into the test, or to modify
> src/seek_sanity_test.c so that it writes the test block-size block
> using pwrite at offset blocksize*42 instead of offset blocksize*10.

That seems like more of an obtuse hack, since it depends on current
default behavior, right?

Explicitly setting the zeroout to 0, with a comment as to why, should
make it clear to the reader of the test I think.

I'll have to look, xfs speculative preallocation fills in holes in
some cases as well, I'm not certain how it behaves on this test.

But we could put in a specific tuning for xfs as well if needed.

If it becomes clear that every fs requires tuning to not opportunistically
fill in holes, then maybe we should make it non-generic, and only support
filesystems we've tested or tuned to work with the testcase.

> I had assumed putting hacks which tweaked sysfs tunables into the
> xfstest script itself would be frowned upon, but if that's considered
> OK, that would be great.

I don't see any real problem with it, myself.

cc: xfs list to see if there are any objections...

-Eric

> 
> 	      	 		       - Ted
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
