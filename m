Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8422B7F9A
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 15:03:58 -0500 (CDT)
Message-ID: <5425C6A6.3060003@sgi.com>
Date: Fri, 26 Sep 2014 22:03:50 +0200
From: Olaf Weber <olaf@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
References: <20140918195650.GI19952@sgi.com> <20140922222611.GZ4322@dastard>
	<5422C540.1060007@sgi.com> <20140924231024.GA4758@dastard>
	<54257D3F.70302@sgi.com> <20140926165605.GA25274@infradead.org>
	<20140926170407.GB6012@samba2> <5425C067.7080904@sgi.com>
	<20140926194656.GC13066@samba2>
In-Reply-To: <20140926194656.GC13066@samba2>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeremy Allison <jra@samba.org>
Cc: tinguely@sgi.com, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, linux-fsdevel@vger.kernel.org

On 26-09-14 21:46, Jeremy Allison wrote:
> On Fri, Sep 26, 2014 at 09:37:11PM +0200, Olaf Weber wrote:
>>
>> My argument against "mount time case-insensitivity" and for "mkfs
>> time case-insensitivity" is related to switching from the
>> case-sensitive domain to the case-insensitive one.
>>
>> For case-sensitive, from "README" to "readme" there are 64 different
>> possible filenames.  Let's say you create 63 out of these 64. Now
>> remount the filesystem case-insensitive, and try to open by the 64th
>> version of "readme". It is not an exact match for any of the 63
>> candidate files, and a case-insensitive match to all 63 candidate
>> files. Which of these 63 files should be opened, and why that one in
>> particular?
>
> I'm ok with "mkfs time case-insensitivity" - really !
> Most of my OEMs would set that and claim victory (few
> of them care much about NFS semantics :-).

I'd say you can have CIFS-style case-insensitive semantics or NFS-style 
case-sensitive semantics, but not both. And in particular, that a customer 
should not actually want to have both.

>>> Having CI matching can speed up Samba operations by a
>>> factor of 10 on large directories (warning, number made
>>> up, depending on the number of entries per dir :-).
>>
>> I really want that to be true, but the proof of the pudding...
>
> No it really *is* true. The reason I can't give
> exact numbers is it depends on the number of entries.
>
> Remember, for every cache *miss*, we have to scan
> the entire directory.
>
> So a user asks for README, and we attempt that
> and it fails. So now we have to enumerate the
> entire directory to see if READMe (or any other
> case varient) exists.
>
> Now do that in a directory with 10, 100, 1000,
> .... 10000000 existing files (don't laugh, I've
> seen an application for Music files that did
> *exactly* that). On a case insensitive filesystem
> you just request README and you're done.
>
> Certain vendors who shall remain nameless :-)
> created test cases of just this example to
> show how much storage on Linux sucks. Not
> a happy camper about that - and telling them
> to use ZFS on FreeBSD or Solaris just doesn't
> feel right :-).

Here's the thing to bear in mind: what I did is a straightforward extension 
of the existing XFS ASCII-based case-insensitive code. If that gets you the 
desired performance improvement, then my code should extend that to more 
general usage. If it doesn't, then there are places in XFS that I haven't 
touched that need modification to have these cases work well.

Olaf

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696796
                            Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-6796
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
