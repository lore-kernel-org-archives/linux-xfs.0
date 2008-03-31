Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Mar 2008 23:11:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2V6B8vH007034
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2008 23:11:14 -0700
Message-ID: <47F08098.3080007@sgi.com>
Date: Mon, 31 Mar 2008 17:11:36 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] fix attr fit checking for filesystems which have
 lost their attr2
References: <47EDCBF9.4070102@sandeen.net> <47F035E3.1030004@sgi.com> <47F06A8B.4090609@sgi.com>
In-Reply-To: <47F06A8B.4090609@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Timothy Shimmin wrote:
> Timothy Shimmin wrote:
>> Hi Eric,
>>
>> Eric Sandeen wrote:
>>> Regarding the F8 corruption...  I have a pretty narrow testcase
>>> now, and it turns out this was a bit of a perfect storm.
>>>
>>> First, F8 shipped 2.6.23 which had the problem with sb_features2
>>> padding out on 64-bit boxes, but this was ok because userspace
>>> and kernelspace both did this, and it was properly mounting &
>>> running as attr2.
>>>
>>> However, hch came along in 2.6.24 and did some endian annotation for 
>>> the superblock and in the process:
>>>> A new helper xfs_sb_from_disk handles the other (read)
>>>> direction and doesn't need the slightly hacky table-driven approach
>>>> because we only ever read the full sb from disk.
>>>
>>> However, this resulted in kernelspace behaving differently,
>>> and now *missing* the attr2 flag in sb_features2, (actually
>>> sb_bad_features2) so we mounted as if we had attr1.  Which is really 
>>> supposed to be ok, IIRC, 
>>
>> Yes, I remember Nathan saying that too ;-)
>>
>>> except in xfs_attr_shortform_bytesfit we return the default
>>> fork offset value from the superblock, even if di_forkoff
>>> is *already* set.  In the error case I had, di_forkoff was set
>>> to 15 (from previously being attr2...) but we returned 14
>>> (the mp default) and I think this is where things started
>>> going wrong; I think this caused us to write an attr on top
>>> of the extent data.
>>>
>>> My understanding of this is that if di_forkoff is non-zero,
>>> we should always be using it for space calculations, regardless
>>> of whether we are mounted with attr2 or not...
>>>
>> That was my understanding as well.
>> I'll have a look at the code soon and see if I can
>> see any problems with the change and the consistency
>> of it all.
>>
>> Thanks a bunch,
>> Tim.
>>
>>> and with that, how's this look, to be honest I haven't run it
>>> through QA yet...
>>>
>>> I'm not certain if xfs_bmap_compute_maxlevels() may lead
>>> to similar problems....
>>>
> Yes, I think it needs to be changed too.
> Looking at the code, it is needed for the log reservation stuff
> where we want to know the size of the space for an EA btree root
> or a data fork extents root, to aid in working out the maximum
> btree level, to work out maximum log space for some transactions.
> So underestimating it is dangerous and overestimating is
> wasteful of logspace.
> It is basing on the same assumption that if we are not mounted
> attr2 then it thinks we are using m_attroffset when we could
> be using di_forkoff.
> However, if di_forkoff is zero then we should use m_attroffset.
> 
Hmmm.
The only problem there is that it is done at mount time assuming
the worst case over all inodes.
So I can't use any di_forkoff but will have to assume like for attr2
the worst case of XFS_BMDR_SPACE_CALC(MIN?BTPTRS).
(Okay I wasn't thinking there ;-)

--tim
