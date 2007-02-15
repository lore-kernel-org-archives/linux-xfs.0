Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Feb 2007 17:30:33 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1F1UPm7004045
	for <linux-xfs@oss.sgi.com>; Wed, 14 Feb 2007 17:30:27 -0800
Date: Thu, 15 Feb 2007 12:19:16 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: mkfs and mount tips?
Message-ID: <5BFF2CB07B4CB49FEC7310C7@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070213085037.216BE12C53@mail.edu.haifa.ac.il>
References: <20070213085037.216BE12C53@mail.edu.haifa.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Leon Kolchinsky <leonk@construct.haifa.ac.il>, linux-xfs@oss.sgi.com

Hi Leon,

--On 13 February 2007 10:48:15 AM +0200 Leon Kolchinsky <leonk@construct.haifa.ac.il> wrote:

> I've also seen "–d unwritten=0" option:
>
> So my question:
> Is it safe to add –d unwritten=0 option to increase performance like this
> (or will I lose some essential functionality)?:
>

My understanding (although I'm not familiar with that code),
is that unwritten extents are used in space preallocation.
So unless you reserve space for a file it will not have an effect.
And if you do, then setting "unwritten=0" will speed up writes because it doesn't
need to flag the unwritten extents and write out the extra transactions for this.
If the unwritten extents aren't flagged as such then there can be a security issue
where one can read old data (other's data) for these unwritten parts.
In fact, the security issue on preallocation (1997-98 sgi-pv#705217) was what motivated
the idea of flagging extents as unwritten in the first place.

--Tim
