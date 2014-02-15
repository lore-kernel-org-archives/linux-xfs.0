Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0562E7F3F
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 21:02:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC6F48F8035
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 19:02:18 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8YsKKvrahazKPfiT for
	<xfs@oss.sgi.com>; Fri, 14 Feb 2014 19:02:18 -0800 (PST)
Message-ID: <52FED8B0.6040009@redhat.com>
Date: Fri, 14 Feb 2014 21:02:08 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: test for atime-related mount options
References: <1392305016-7424-1-git-send-email-koen.de.wit@oracle.com>
	<52FCF60F.6030703@sandeen.net>
	<20140214163925.GW16073@twin.jikos.cz>
	<52FE472C.8070503@sandeen.net> <20140214222418.GT13997@dastard>
	<52FEAB6B.10107@redhat.com> <20140215013931.GT13647@dastard>
In-Reply-To: <20140215013931.GT13647@dastard>
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
Cc: Koen De Wit <koen.de.wit@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, dsterba@suse.cz, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 2/14/14, 7:39 PM, Dave Chinner wrote:
> On Fri, Feb 14, 2014 at 05:48:59PM -0600, Eric Sandeen wrote:
>> On 2/14/14, 4:24 PM, Dave Chinner wrote:
>>> On Fri, Feb 14, 2014 at 10:41:16AM -0600, Eric Sandeen wrote:
>>>> On 2/14/14, 10:39 AM, David Sterba wrote:
>>>>> On Thu, Feb 13, 2014 at 10:42:55AM -0600, Eric Sandeen wrote:
>>>>>>> +cat /proc/mounts | grep "$SCRATCH_MNT" | grep relatime >> $seqres.full
>>>>>>> +[ $? -ne 0 ] && echo "The relatime mount option should be the default."
>>>>>>
>>>>>> Ok, I guess "relatime" in /proc/mounts is from core vfs code and
>>>>>> should be there for the foreseeable future, so seems ok.
>>>>>>
>>>>>> But - relatime was added in v2.6.20, and made default in 2.6.30.  So
>>>>>> testing older kernels may not go as expected; it'd probably be best to
>>>>>> catch situations where relatime isn't available (< 2.6.20) or not
>>>>>> default (< 2.6.30), by explicitly mounting with relatime, and skipping
>>>>>> relatime/strictatime tests if that fails?
>>>>>
>>>>> Is there some consensus what's the lowest kernel version to be supported
>>>>> by xfstests? 2.6.32 is the lowest base for kernels in use today, so
>>>>> worrying about anything older does not seem necessary.
>>>>>
>>>>
>>>> I don't know that it's been discussed - selfishly, I know our QE uses
>>>> xfstests on RHEL5, which is 2.6.18-based.
>>>
>>> Sure, but they can just add the test to a "rhel5-expunged" file and
>>> they don't have to care about tests that won't work on RHEL 5 or
>>> other older kernels. Or to send patches to add "_requires_relatime"
>>> so that it automatically does the right thing for older kernels.
>>
>> sure but some of this test is still valid on a kernel w/o relatime.
>> And since it's the default, "relatime" might disappear from /proc/mounts
>> some day anyway, so explicitly mounting with the option & failing
>> if that fails might be good future-proofind in any case.
>>
>> *shrug*
>>
>> It was just a request, not a demand.  :)  Koen, you can do with
>> it whatever you like.  Reviews aren't ultimatums.  :)
>>
>> If xfstests upstream is only targeted at the current kernel, that's
>> fine, but maye we should make that a little more explicit.
> 
> That's not what I meant. ;)
> 
> Really, all I'm saying is that we can't expect people who are
> writing tests that work on current kernels to know what is necessary
> to make tests work on 7 year old distros that don't support a
> feature that has been in mainline for 5 years. Hence that shouldn't
> be a barrier to having a test committed as we have mechanisms for
> distro QE to handle these sorts of issues...

Sure, that's perfectly fair.

I wasn't really thinking of RHEL5 when I made my first comment,
just general portability across kernels.  dsterba suggested that
2.6.32 is the oldest kernel used, and I pointed out that we do
still use 2.6.18.  :)

Anyway, for general portability across releases, perhaps rather than:

+cat /proc/mounts | grep "$SCRATCH_MNT" | grep relatime >> $seqres.full
+[ $? -ne 0 ] && echo "The relatime mount option should be the default."

which would fail the test, it should just [notrun] if relatime
isn't there, for any reason, on any kernel, if relatime is not
default as expected for the test framework.  i.e.

+[ $? -ne 0 ] && _notrun "The relatime mount option is not the default."

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
