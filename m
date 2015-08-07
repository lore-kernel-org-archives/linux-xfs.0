Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0EEFD7F58
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 11:42:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D927C8F8033
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 09:42:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id SZJKGLiNZRMBlhkn for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 09:42:51 -0700 (PDT)
Message-ID: <55C4E007.90709@sandeen.net>
Date: Fri, 07 Aug 2015 09:42:47 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs.xfs: fix ftype-vs-crc option combination testing
References: <55C43FBA.1080408@sandeen.net>
	<20150807113742.GB8322@bfoster.bfoster>
In-Reply-To: <20150807113742.GB8322@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Jan Tulak <jtulak@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 8/7/15 4:37 AM, Brian Foster wrote:
> On Thu, Aug 06, 2015 at 10:18:50PM -0700, Eric Sandeen wrote:
>> mkfs.xfs got weird along the way; today it has different outcomes
>> depending on the order of option specification:
>>
>> $ mkfs/mkfs.xfs -n ftype=1 -m crc=0 -dfile,name=fsfile,size=16g
>> cannot specify both crc and ftype
>> $ mkfs/mkfs.xfs -m crc=0 -n ftype=1 -dfile,name=fsfile,size=16g
>> <succeeds>
>>
>> Somehow the tests got written as being constrained on what options
>> are specified - and in what order! - vs actually testing for
>> incompatible feature sets.
>>
> 
> IIRC, I think this is one of the core problems the big mkfs option
> parsing rework that Jan is working on is supposed to fix.

Yeah, I think so - Jan, if this gets in your way, let us know - 
I didn't mean to make your life difficult by fixing little
things while you work.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
