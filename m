Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 194D77F37
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 16:24:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EDE6D304032
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 14:24:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id WLREVGCSCJUiaDSl for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 14:24:25 -0700 (PDT)
Message-ID: <525C6108.6010108@sandeen.net>
Date: Mon, 14 Oct 2013 16:24:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: projid32bit=1 default in xfsprogs-3.2.0
References: <525C1C15.7020204@sandeen.net> <20131014211659.GI5663@dastard>
	<20131014212347.GB1935@sgi.com>
In-Reply-To: <20131014212347.GB1935@sgi.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/14/13 4:23 PM, Ben Myers wrote:
> On Tue, Oct 15, 2013 at 08:16:59AM +1100, Dave Chinner wrote:
>> On Mon, Oct 14, 2013 at 11:30:13AM -0500, Eric Sandeen wrote:
>>> The commit:
>>>
>>> f3edb66a mkfs.xfs: validate options for CRCs up front.
>>>
>>> unintentionally (?) defaulted to projid32bit=1 for all filesystems
>>> at mkfs time.
>>
>> It wasn't unintentional, I just forgot to document it.
>>
>>> Support for 32 bit project IDs has been present since kernel v2.6.37.
>>
>> Right, so taking the usual approach to these things, all the
>> distro's now ship kernels that support 32 bit project IDs, so there
>> is no reason for mkfs.xfs in a new xfsprogs release not to set it
>> by default.
> 
> I'm not seeing much downside to turning on 32 bit project IDs by default in
> 3.2.0.  Sounds good to me.
> 
> -Ben
> 

Ok.  Default it is!   Thanks guys, just wanted to make sure we were
all in agreement there.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
