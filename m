Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7UGhf08012284 for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 11:43:42 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91D7DD6DB76
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 09:54:43 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id zHYXqZ43if7AFuWi for
	<xfs@oss.sgi.com>; Mon, 30 Aug 2010 09:54:43 -0700 (PDT)
Message-ID: <4C7BDFE1.10804@sandeen.net>
Date: Mon, 30 Aug 2010 11:44:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs: minimum version with these commands
References: <4C7A2654.3080106@op.pl> <4C7B0EF6.5030505@sandeen.net>
	<4C7BDDB1.6030209@op.pl>
In-Reply-To: <4C7BDDB1.6030209@op.pl>
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
To: Bogdan <bogdandr@op.pl>
Cc: xfs@oss.sgi.com

Bogdan wrote:
> On 30.08.2010 03:52, Eric Sandeen wrote:
>> Bogdan wrote:
>>>  Hello.
>>>
>>>  I couldn't find this information in the xfsprogs ChangeLog, so I'm
>>> asking here: what is the minimum version of xfsprogs to:
>>>
>>> 1) contain these utilities: xfs_db, xfs_freeze, xfs_check, and
>>> 2) xfs_db accepts the following command-line parameters: -i, -c, and
>>> 3) xfs_freeze accepts the following command-line parameters: -f, -u, and
>>> 4) xfs_db accepts the following interactive mode commands: "freesp
>>> -d", "quit", "blockget -n", "ncheck", "sb 0", "print".
>> I am not surprised that changelogs do not mention when "quit" was
>> added to xfs_db ...!
> 
>  It could have been "exit" one day in the past, right?

It could have been, but if it was "quit" from day one, that's never
going to make it to a changelog.  :)

>>>  Or is there a ChangeLog that covers all xfsprogs versions in such
>>> deatil that I would be able to find this myself? If so, where can I
>>> find it?
>>>
>> You could look at git and/or cvs history/blame to see when commands & 
>> options were added.
> 
>  Is everything really there? How do I get these?

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsdump.git

http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/

Most everything should be there.


>> Most of the things you ask about are SO OLD it will take some digging
>> through renames and moves.
> 
>  I thought so. I'm surprised such things as added commands aren't in
> the ChangeLog, unless they were present from the first version.
> 
>> Do you really need to know if "xfs_check" was added in 1994, or 1995, for
>> example? :)
> 
>  No. I need to know what was the first version of the xfsprogs package
> that contained this program. The version number, not the year.

well, equivalently, do you care if it was version 1.0.0 or 1.0.1, from the
1990's era.

For everything you asked about, I think they've all been there since
inception.

I think picking a version from maybe 5 years ago and checking that the
commands are all there would suffice; it would be -very- unlikely that
anything older is still in use.

>> This strikes me as a bit of an odd question; what is your motivation here?
> 
>  I'm writing a program that executes xfs_db and other processes,
> passes commands to them and reads replies. Now I want to know what the
> minimum required version is to be sure that these commands are
> accepted. I know this might seem strange, but I'd like to know this in
> more detail, so I can say "requires xfsprogs version X.Y.Z or newer"
> instead of "requires xfsprogs" (which would imply that all versions
> work, and this might not be the case). If it would be "1.0.0", great.
> But I wanted to be sure.

Ok, understood.

I think the fastest route, since nothing you asked for is particularly
"new" would be to just grab a sufficiently old version and double check
that the commands are there.  Easier than chasing through the repository,
I think.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
