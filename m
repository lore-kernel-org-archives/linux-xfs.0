Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7BF267F37
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 15:06:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5A3BC8F8049
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 13:06:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zkNYLKzvHMoID1im for <xfs@oss.sgi.com>;
	Tue, 28 Oct 2014 13:06:46 -0700 (PDT)
Message-ID: <544FF755.1010705@sandeen.net>
Date: Tue, 28 Oct 2014 15:06:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Kernel crashes with trace ending in XFS code on RHEL6 variant
	kernel
References: <CA+tQb7GSvkgsxZT2awAkMjh9wY6JXBygLoenTrtFtmRMSVwuUA@mail.gmail.com>	<544FD577.9040605@sandeen.net>
	<CAAxjCEyTq5UfmqzBbtXXQ=vWoHmCG5WJvLGsSwCfRL0P4qnCJw@mail.gmail.com>
In-Reply-To: <CAAxjCEyTq5UfmqzBbtXXQ=vWoHmCG5WJvLGsSwCfRL0P4qnCJw@mail.gmail.com>
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: Jan Kokoska <jan@glow.cz>, Linux fs XFS <xfs@oss.sgi.com>

On 10/28/14 3:01 PM, Stefan Ring wrote:
> On Tue, Oct 28, 2014 at 6:42 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 10/28/14 10:38 AM, Jan Kokoska wrote:
>>> Hi,
>>>
>>> I'm running OpenVZ (OS container) kernel variant of RHEL6 kernel on
>>
>> ... for which we have no source code? ;)
>>
>> I don't know what's in "2.6.32-openvz-amd64" so can't help much.
>>
>> What is at line 86 of xfs_aops.c in that kernel?
> 
> From my quick investigation, it would seem to be the line "bh = head =
> page_buffers(page);" of xfs_count_page_state.

Yes, I think you're right, but my point is this is a kernel which we don't
maintain.

Anyway, I don't know for sure offhand what this could be; 
upstream ef5d437f71afdf4afdbab99213add99f4b1318fd looks related, but
TBH I'm not sure if it's specific to S390.

-Eric




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
