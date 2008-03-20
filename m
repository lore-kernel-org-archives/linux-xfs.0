Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 17:35:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2K0ZHWc010732
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 17:35:19 -0700
Message-ID: <47E1B15E.5050107@sgi.com>
Date: Thu, 20 Mar 2008 11:35:42 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <b1b17e290803181631x60a3e921l836b115c3b026773@mail.gmail.com> <47E085F3.8030908@sandeen.net> <47E0A07D.5090803@sandeen.net>
In-Reply-To: <47E0A07D.5090803@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Andre Draszik <xfs@andred.net>, xfs@oss.sgi.com

Eric Sandeen wrote:
> Eric Sandeen wrote:
> 
>> I've helpfully provided structure layouts for the structures you mention
>> in the attached files, for your diffing pleasure.  I think you'll find
>> that it's not exactly as you described.
> 
> Ah hell the arm structs I attached were for oldabi.  It's what I get for
> saving this fun work for late at night ;)
> 
> Attached are eabi structs; still only xfs_dir2_data_entry, xfs_dinode
> and xfs_log_item seem to be affected by end-of-struct padding, of the
> structures you mention.  And xfs_log_item isn't a disk structure...
> 
> which brings me back to, what specific failures do you see as a result
> of end-of-struct padding on these structs?
> 
Which reminds me when writing 122 that I noticed with xfs_dinode
but didn't think the end of struct padding would affect things -
remember chatting to Nathan at the time IIRC.
Actually, now that I think about it (Tim waking up a bit :-),
the xfs_dinode_t is of limited value, because a lot of those
union fields at the end aren't actually used directly and just
give an indication of what the layout is like.
We are in the variable literal area there.


--Tim
