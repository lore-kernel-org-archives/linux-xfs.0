Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 078197F50
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 15:23:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E86378F8094
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 13:23:32 -0700 (PDT)
Received: from mail-ig0-f180.google.com (mail-ig0-f180.google.com
	[209.85.213.180]) by cuda.sgi.com with ESMTP id
	38ipWEdveWDPFkX3 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 13:23:30 -0700 (PDT)
Received: by igbqf9 with SMTP id qf9so8069170igb.1
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 13:23:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150324153306.GG4701@suse.de>
References: <1427113443-20973-1-git-send-email-mgorman@suse.de>
	<20150324115141.GS28621@dastard> <20150324153306.GG4701@suse.de>
Date: Tue, 24 Mar 2015 13:23:30 -0700
Message-ID: <CA+55aFzPCbfMKPEpxntCvEK_SqjbBTppyZMW7W2C+ppnA4W4fw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Reduce system overhead of automatic NUMA balancing
From: Linus Torvalds <torvalds@linux-foundation.org>
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
To: Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linux-MM <linux-mm@kvack.org>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, ppc-dev <linuxppc-dev@lists.ozlabs.org>, Ingo Molnar <mingo@kernel.org>

On Tue, Mar 24, 2015 at 8:33 AM, Mel Gorman <mgorman@suse.de> wrote:
> On Tue, Mar 24, 2015 at 10:51:41PM +1100, Dave Chinner wrote:
>>
>> So it looks like the patch set fixes the remaining regression and in
>> 2 of the four cases actually improves performance....
>
> \o/

W00t.

> Linus, these three patches plus the small fixlet for pmd_mkyoung (to match
> pte_mkyoung) is already in Andrew's tree. I'm expecting it'll arrive to
> you before 4.0 assuming nothing else goes pear shaped.

Yup. Thanks Mel,

                          Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
