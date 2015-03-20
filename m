Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6C08D7F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 10:26:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0ADB7AC006
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 08:26:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id tTtqjxP0a60hEVzH for <xfs@oss.sgi.com>;
	Fri, 20 Mar 2015 08:26:50 -0700 (PDT)
Message-ID: <550C3C39.8050400@sandeen.net>
Date: Fri, 20 Mar 2015 10:26:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs: default to CRC enabled filesystems
References: <1426720967-8215-1-git-send-email-david@fromorbit.com>	<550AE35D.40006@sandeen.net>
	<20150319231323.GK10105@dastard>
In-Reply-To: <20150319231323.GK10105@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 3/19/15 6:13 PM, Dave Chinner wrote:
> On Thu, Mar 19, 2015 at 09:55:25AM -0500, Eric Sandeen wrote:

...

>> Problem here is that if both are explicitly specified, one is ignored, rather
>> than letting the user know they've selected an invalid set of options:
> 
> Yup, I explicitly made that choice: turning off CRCs immediately
> turns off all functionality dependent on it. Especially as the
> number of errors being thrown by xfstests when run with
> MKFS_OPTIONS="-m crc=0".
> 
>> # mkfs/mkfs.xfs -dfile,name=fsfile,size=1g -m crc=0,finobt=1
>> meta-data=fsfile                 isize=256    agcount=4, agsize=65536 blks
>>          =                       sectsz=512   attr=2, projid32bit=1
>>          =                       crc=0        finobt=0
>> ...
> 
>> This might require a "finobtflag" to keep track of whether it's user-specified,
>> as we do with other options?
> 
> I *hate* the profusion of flags in mkfs just to detect this sort of
> thing. This is a clear case where "do what I mean" rather than "do
> what I say" is the prefered behaviour - the current code is a
> horrible mess because it tries handle every weird combination of "do
> what I say" with some error message.
> 
> I'll change it to add the stupid error message back in and go and
> write all the patches for xfstests not to fail because we changed
> mkfs defaults...

Oops, I accidentally missed reply-all last time.

I just think that silently changing an explicitly-specified option seems
like a bad idea.

Perhaps if defaults are specified before getopt, the getopt handlers can
flag the incorrect combination, and bail without the extra flag.

I don't see how this requires xfstests rework, though?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
