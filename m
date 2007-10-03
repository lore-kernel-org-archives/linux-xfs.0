Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 18:31:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l931V4i0014599
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 18:31:11 -0700
Message-ID: <4702F0CD.1070300@sgi.com>
Date: Wed, 03 Oct 2007 11:30:53 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: REVIEW: xfs_reno
References: <op.tzj549h63jf8g2@pc-bnaujok.melbourne.sgi.com> <20071002090216.GA22721@infradead.org> <20071002091951.GE995458@sgi.com>
In-Reply-To: <20071002091951.GE995458@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

David Chinner wrote:
> At that point, we'll got a "working" shrink that will allow
> shrinking to only 50% of the original size because the log will
> get in the way. To fix that, we'll need to implement transactions
> to move the log...
> 
Moving the log sounds pretty tricky.

Either we'd need to clean out the log (a la freeze) or
copy the active part (tail->head) to the new location and zero out the rest of
the new log space (or may even need to write sectors with
previous cycle#s at the start of each sector for the rest).
So how would one do that with the copying approach because
we'd need to be writing in to the new log and we'd need the log
pointer in the superblock to be logged somewhere ughhhh.
I think a type of freezing may be the way to go.
The trouble is we need to point the sb to the new log and the
only place to log that is in the old log.
So I guess before unfreezing you write the sb logptr change
using the old log and then after the unfreeze, everything uses the new log.
If you die before the sb change to disk then on mount you replay the sb change
using the old log and then start writing to the new log. If you die before writing the
sb change in the old log then you are stuck.
You need this log change and freespace change (for making room for the log)
in a transaction together and probably with other stuff.
Okay, I'm getting lost :)

--Tim
