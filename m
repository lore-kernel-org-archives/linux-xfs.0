Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 44C5829DFB
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 18:50:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E39A3AC002
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 16:50:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4Lu6xulQ1uzXgHlG for <xfs@oss.sgi.com>;
	Mon, 11 May 2015 16:50:02 -0700 (PDT)
Message-ID: <55514028.6010606@sandeen.net>
Date: Mon, 11 May 2015 18:50:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: create new metadata UUID field and incompat flag
References: <554D1F56.7030209@redhat.com>
	<554D2110.8030405@sandeen.net>	<20150511161404.GA54361@bfoster.bfoster>	<5550DE64.2030907@sandeen.net>
	<20150511214902.GG15721@dastard>
In-Reply-To: <20150511214902.GG15721@dastard>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Brian Foster <bfoster@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 5/11/15 4:49 PM, Dave Chinner wrote:
> On Mon, May 11, 2015 at 11:52:52AM -0500, Eric Sandeen wrote:
>> On 5/11/15 11:14 AM, Brian Foster wrote:
>>> On Fri, May 08, 2015 at 03:48:16PM -0500, Eric Sandeen wrote:
>>>>> This adds a new superblock field, sb_meta_uuid.  If set, along with
>>>>> a new incompat flag, the code will use that field on a V5 filesystem
>>>>> to compare to metadata UUIDs, which allows us to change the user-
>>>>> visible UUID at will.  Userspace handles the setting or clearing
>>>>> of the incompat flag as appropriate, as the UUID gets written.
>>>>>
>>>>> If the incompat flag is not set, copy the user-visible UUID into
>>>>> into the meta_uuid slot in memory; this is not written back to disk in
>>>>> this case.
>>>>>
>>>>> The remainder of this patch simply switches verifiers, initializers,
>>>>> etc to use the new sb_meta_uuid field.
>>>>>
>>>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>>> ---
>>> This all looks fine to me. The only thing that confuses me is why we
>>> continue to use sb_uuid for the log. Eric points out on irc that we
>>> can't modify the uuid when the log is dirty, so we can't actually break
>>> anything in this manner. In other words, we effectively already handle a
>>> modified uuid with respect to the log.
>>>
>>> That said, it seems inconsistent to me to create a metadata uuid field
>>> and not use it for all metadata. My expectation from such a change is to
>>> see sb_uuid now used only for user facing bits (e.g., mount and get geo
>>> related) and sb_meta_uuid used everywhere else. Instead, we use sb_uuid
>>> for the user facing bits, sb_meta_uuid for the internal bits that can't
>>> handle a uuid change and sb_uuid for the internal bits that can.
>>>
>>> I suppose I could be convinced otherwise if there's context I'm missing,
>>> but otherwise this seems a bit confusing to me...
>>>
>>> Brian
>>
>> Yeah, I'm sympathetic to that argument.  I can look into using sb_meta_uuid
>> for the log too, if the incompat flag is set.
> 
> The log uuid is user facing, like the superblock uuid. i.e. there
> are tools that identify external log devices by checking that the
> uuid in the log matches the user facing uuid in the superblock.
> Hence the log uuid needs to use the uuid that is reported to
> userspace.


None that are external to xfsprogs, I think, are there? (1) - but still.
I'm happy to leave it as it is ... I don't think it really matters either way.

-Eric

(1) at one point I wanted to teach blkid to find an external log by UUID,
but there is no "log superblock" so I gave up on that idea.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
