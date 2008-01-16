Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jan 2008 03:52:25 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0GBqDm9013510
	for <xfs@oss.sgi.com>; Wed, 16 Jan 2008 03:52:17 -0800
Message-ID: <478DEFF0.40004@sgi.com>
Date: Wed, 16 Jan 2008 22:52:16 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: Question related to XFS sync , especially fsync
References: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>	 <20080114224245.GT155259@sgi.com>	 <d711080c0801150544i53d7abb2hbea659116ce0006b@mail.gmail.com>	 <478CCEAC.9010008@sandeen.net>	 <1200436012.9463.184.camel@edge.scott.net.au>	 <d711080c0801152243h7613bbean9daeab8658f75408@mail.gmail.com>	 <20080116064840.GA5725@puku.stupidest.org>	 <d711080c0801152325g3d57965dm92e3687a5f98c5f6@mail.gmail.com>	 <20080116082502.GA24175@infradead.org> <d711080c0801160100r7ae091f8k9c8f0f0152b9f203@mail.gmail.com>
In-Reply-To: <d711080c0801160100r7ae091f8k9c8f0f0152b9f203@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Gopala Krishna <gopalakrishna.n.m@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Wedgwood <cw@f00f.org>, nscott@aconex.com, xfs@oss.sgi.com

Gopala,

it sounds like you want something like NDMP. Check that out first.

-- Mark

Gopala Krishna wrote:
> Thanks for the suggestions!.  I will relook at the my idea and
> design....implemetation. As of now what we are doing is in experimental
> stage.
> 
> Thanks,
> Gopal.
> 
> 
> On 1/16/08, Christoph Hellwig <hch@infradead.org> wrote:
>> On Wed, Jan 16, 2008 at 12:55:17PM +0530, Gopala Krishna wrote:
>>> While  replying  to Eric, I mentioned why we are doing that. We are
>>> basically providing interfaces to back up applications in a pure storage
>>> environment that deals with the  back up at block level (sector level)
>> and
>>> hence depending upon different file system, we need to get information
>> about
>>> file like it's extent information and associated block numbers etc.
>> This basically can't work.  If you do a plain block based backup you
>> need to freeze the filesystem first and then either backup through a
>> newly created snapshot or the raw device.  Alternatively you can do
>> file-based backups assisted by the bulkstat interface as done by
>> xfsdump.  If you try to mix the two layers you get into deep trouble
>> due to various issues:
>>
>> - knowledge of the disk format.  The ondisk format can change anytime
>>   and will break your application.  And yes, additions to the ondisk
>>   format do happen quite frequently.
>> - no coherency between the filesystem and the block device node.  This
>>   is especially true for backup applications which use the buffered
>>   block device nodes because there is a real-life chance that stale
>>   cache is around
>> - no guarantee that the ondisk image is actually update.  XFS like
>>   most other current filesystems uses an intent log to provide
>>   reliabily and sync is only guaranteed to push updates into the log
>>   but not actually write it back to it's "normal" location on disk.
>>
>> In short what you're trying to do is a road to disaster, so don't do it!
>>
>> Note that the problems apply to any filesystem in one way or another,
>> not just XFS.
>>
>>
> 
> 
> [[HTML alternate version deleted]]
> 
> 

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
