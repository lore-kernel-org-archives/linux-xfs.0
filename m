Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5FC7829E01
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 14:37:18 -0500 (CDT)
Message-ID: <5425C067.7080904@sgi.com>
Date: Fri, 26 Sep 2014 21:37:11 +0200
From: Olaf Weber <olaf@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
References: <20140918195650.GI19952@sgi.com> <20140922222611.GZ4322@dastard>
	<5422C540.1060007@sgi.com> <20140924231024.GA4758@dastard>
	<54257D3F.70302@sgi.com> <20140926165605.GA25274@infradead.org>
	<20140926170407.GB6012@samba2>
In-Reply-To: <20140926170407.GB6012@samba2>
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
To: Jeremy Allison <jra@samba.org>, Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, tinguely@sgi.com, xfs@oss.sgi.com

On 26-09-14 19:04, Jeremy Allison wrote:
> On Fri, Sep 26, 2014 at 09:56:05AM -0700, Christoph Hellwig wrote:
>>
>> My take on this is:
>>
>>   - I think we'll have to prevent non-utf8 file names for any cases where
>>     we use utf8 normalization.  If you do not use utf8 normalization
>>     it's plain old Unix everything is allowed.
>>
>>   - I think utf8 normalization vs not should be mkfs option, to make sure
>>     everyone including kernel and repair knows what sort of filesystem
>>     deal with.
>>
>>   - case insensitive matching for utf8 normalized filesystems should be
>>     a runtime decision.  mount time for now, but Samba people would be
>>     extremly happy to allow per-operation or per-process CI matching.
>>     But that is another totally different discusion I'd like to keep
>>     separate, I just want to make sure the disk format allows for it for
>>     now.
>
> Actually, I'm so eager for case-insensitive matching I'd
> take "at format time", as with ZFS :-) :-).

My argument against "mount time case-insensitivity" and for "mkfs time 
case-insensitivity" is related to switching from the case-sensitive domain 
to the case-insensitive one.

For case-sensitive, from "README" to "readme" there are 64 different 
possible filenames.  Let's say you create 63 out of these 64. Now remount 
the filesystem case-insensitive, and try to open by the 64th version of 
"readme". It is not an exact match for any of the 63 candidate files, and a 
case-insensitive match to all 63 candidate files. Which of these 63 files 
should be opened, and why that one in particular?

> Having CI matching can speed up Samba operations by a
> factor of 10 on large directories (warning, number made
> up, depending on the number of entries per dir :-).

I really want that to be true, but the proof of the pudding...

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
