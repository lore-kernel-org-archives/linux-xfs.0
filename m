Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 26 Mar 2007 21:57:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2R4vd6p007222
	for <xfs@oss.sgi.com>; Mon, 26 Mar 2007 21:57:41 -0700
Date: Tue, 27 Mar 2007 14:58:06 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: XFS and write barriers.
Message-ID: <E4668B41AB231E3CEA239371@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070325031927.GG32602149@melbourne.sgi.com>
References: <17923.11463.459927.628762@notabene.brown>
 <1755676AA526FF7790546385@timothy-shimmins-power-mac-g5.local>
 <17923.35118.139991.252734@notabene.brown> <20070325031927.GG32602149@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Neil Brown <neilb@suse.de>
Cc: xfs@oss.sgi.com

--On 25 March 2007 2:19:27 PM +1100 David Chinner <dgc@sgi.com> wrote:

> On Fri, Mar 23, 2007 at 07:00:46PM +1100, Neil Brown wrote:
>> On Friday March 23, tes@sgi.com wrote:
>> > >
>> > > I think this test should just be removed and the xfs_barrier_test
>> > > should be the main mechanism for seeing if barriers work.
>> > >
>> > Oh okay.
>> > This is all Christoph's (hch) code, so it would be good for him to comment here.
>> > The external log and readonly tests can stay though.
>> >
>>
>> Why no barriers on an external log device??? Not important, just
>> curious.
>
> because we need to synchronize across 2 devices, not one, so issuing
> barriers on an external log device does nothing to order the metadata
> written to the other device...
>

I have wondered in the past (sgi-bug#954969) about doing a blk_issue_flush
on the metadata device at xlog_sync time prior to the log write on
the log device.

  27/July/06 - pv#954969
  Currently, if one uses external logs then the barrier support is turned off.
  The reaon for this is that a write barrier is normally only done on the data
  device which has the log.
  With an external log it means that a write barrier on a log device will not
  do any flushing on the metadata device.
  This pv is opened to explore the possibility of issuing an explicit metadata
  device flush at xlog_sync time before doing a write barrier on the log data
  to the log device.
  This would guarantee if the tail moved because a metadata thought its
  data was really on disk, would now be true as we would do a flush of
  its device. Then we could do our log write without worrying that
  our log write will overwrite log data when its metadata hadn't really made it.
  Perhaps I'm missing something.
  Dave (dgc) said he'd think about it.
  I haven't heard back from Christoph yet, and he added the
  code for our barrier support in xfs.
  --Tim

--Tim
