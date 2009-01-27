Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0RHS7G7062385 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 11:28:08 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 05B63BEA27
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 09:27:25 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id JgChHHBKiNnYivdj for <xfs@oss.sgi.com>;
	Tue, 27 Jan 2009 09:27:25 -0800 (PST)
Message-ID: <497F43DE.4010402@sandeen.net>
Date: Tue, 27 Jan 2009 11:26:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Strange fragmentation in nearly empty filesystem
References: <20090123102130.GB8012@doctronic.de>	<20090124003329.GE32390@disturbed>	<20090126075724.GA1753@doctronic.de>
	<497E02CD.2020000@sandeen.net>	<20090127071023.GA16511@doctronic.de>	<20090127084034.GA16931@doctronic.de>	<497F0C78.7060501@sandeen.net>
	<20090127143724.GP16931@doctronic.de>
In-Reply-To: <20090127143724.GP16931@doctronic.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Carsten Oberscheid <oberscheid@doctronic.de>
Cc: xfs@oss.sgi.com

Carsten Oberscheid wrote:
> On Tue, Jan 27, 2009 at 07:30:32AM -0600, Eric Sandeen wrote:
>> It'd be best to run vmware under some other kernel, and observe its
>> behavior, not just mount some existing filesystem and look at existing
>> files and do other non-vmware-related tests.
> 
> If this really is just a vmware and/or kernel problem that has nothing
> to do with the filesystem, then I agree.

well when I say "kernel" I include the filesystem in that kernel.  :)

>> You went from a file with 34 holes to one with 27k holes by copying it?
> 
> Yep.
> 
>>  Perhaps this is cp's sparse file detection in action, seeking over
>> swaths of zeros.
> ...
>> Perhaps, if by "worse" you mean "leaves holes for regions with zeros".
>> Try cp --sparse=never and see how that goes.
> 
> Didn't know this one.
> 
> 
> [co@tangchai]~/vmware/foo cp --sparse=never foo.vmem test_nosparse
> 
> [co@tangchai]~/vmware/foo xfs_bmap -vvp test_ | grep hole | wc -l
> test_livecd    test_nosparse  
> 
> [co@tangchai]~/vmware/foo xfs_bmap -vvp test_nosparse | grep hole | wc -l
> 0
> 
> [co@tangchai]~/vmware/foo xfs_bmap -vvp test_nosparse | grep -v hole | wc -l
> 9
> 
> 
> You win.

\o/  :)

>> My best guess is that your cp test is making the file even more sparse
>> by detecting blocks full of zeros and seeking over them, leaving more
>> holes.  Not really related to vmware behavior, though.
> 
> All right. So next I'll try and downgrade vmplayer.
> 
> Just out of couriosity (and stubbornness): Are there any XFS
> parameters that might influence fragmentation for the better, in case
> I have to put up with a stupid application?
> 
> Thanks for your time & thoughts & best regards

There is an -o allocsize=<number> which controls how much is
speculatively allocated off the end of a file; in some cases it could
help but I'm not sure it would in this case.  As Dave said a while ago,
it's really an issue with how vmware is writing the files out.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
