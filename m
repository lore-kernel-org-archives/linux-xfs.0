Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 54B917FAA
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 11:16:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F28AEAC00A
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 09:15:58 -0700 (PDT)
Received: from mail-ie0-f180.google.com (mail-ie0-f180.google.com
	[209.85.223.180]) by cuda.sgi.com with ESMTP id
	HZ3pqaJAi8IkAXhh (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 09:15:58 -0700 (PDT)
Received: by mail-ie0-f180.google.com with SMTP id e14so5248137iej.39
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 09:15:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131031155503.GO1935@sgi.com>
References: <5265C03B.50701@sandeen.net> <20131022001732.GI4446@dastard>
	<CAGG-pUTh-PJJ4Nzo0r-f3VDPMc81U2z_NMX+Wcex3KzGs=U8cA@mail.gmail.com>
	<20131022203946.GB2797@dastard> <5266E4BD.8030601@sandeen.net>
	<20131022210300.GC2797@dastard> <5266EBF0.901@sandeen.net>
	<CAGG-pUTtYomspBXn=RE7YFU=vu6rWZ1fU7CBO45Mmodj8DZFiQ@mail.gmail.com>
	<20131023203435.GR1935@sgi.com> <5271672C.7070101@sandeen.net>
	<20131031155503.GO1935@sgi.com>
Date: Thu, 31 Oct 2013 14:15:57 -0200
Message-ID: <CAGG-pUQawQ0WGkL9tovQ+ejpmAvEpkrOB-uznD03SjBMUcmAJA@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix possible NULL dereference
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, open list <linux-kernel@vger.kernel.org>, XFS FILESYSTEM <xfs@oss.sgi.com>

2013/10/31 Ben Myers <bpm@sgi.com>:
> Hey Geyslan,
>
> On Wed, Oct 30, 2013 at 03:08:12PM -0500, Eric Sandeen wrote:
>> On 10/23/13 3:34 PM, Ben Myers wrote:
>>
>> > xfs: fix possible NULL dereference in xlog_verify_iclog
>> >
>> > In xlog_verify_iclog a debug check of the incore log buffers prints an
>> > error if icptr is null and then goes on to dereference the pointer
>> > regardless.  Convert this to an assert so that the intention is clear.
>> > This was reported by Coverty.
>> >
>> > Reported-by: Geyslan G. Bem <geyslan@gmail.com>
>> > Signed-off-by: Ben Myers <bpm@sgi.com>
>>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>
> Applied this.  Many thanks!  ;)
>
> -Ben

It was a pleasure. o/

-- 
Regards,

Geyslan G. Bem
hackingbits.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
