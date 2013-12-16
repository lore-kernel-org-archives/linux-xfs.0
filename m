Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC7277F3F
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 01:41:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5AA32AC005
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 23:41:20 -0800 (PST)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id Zv1Ks7QzHYQDq4eA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 15 Dec 2013 23:41:18 -0800 (PST)
Message-ID: <52AEAE99.7060001@tlinx.org>
Date: Sun, 15 Dec 2013 23:41:13 -0800
From: LA Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: usefulness of 'security attr' being non-copiable on discretionary
	access linux.
References: <52A96211.3050602@tlinx.org> <20131212181315.GB20500@samba2>
	<52AAC7CC.8000802@tlinx.org> <20131213105314.GA2117@infradead.org>
	<52AB7CDC.5040801@tlinx.org> <52ADBB00.8050707@tlinx.org>
	<20131215235443.GT31386@dastard> <52AE6364.7010106@tlinx.org>
	<20131216030215.GW31386@dastard>
In-Reply-To: <20131216030215.GW31386@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>



On 12/15/2013 7:02 PM, Dave Chinner wrote:
> It writes it into the "trusted" VFS xattr namespace which means it
> knows *nothing* about how XFS stores it's xattrs on disk.
----

I never said it was correct, Dave.  At best, I thought it might have
represented some state in the past.


>> -----
>>    I'm running with the "default" security (Discretionary -
>> mode bits + access lists + cap bits slowly supplanting need for root.
> 
> So, did you turn the distro default selinux config off?
----
Suse ships AppArmor enabled by default, not selinux.

I run my own kernel from kernel.org sources.  (Suse doesn't
support booting directly  from disk, and /usr is expected
to be mounted when the OS starts coming up (they put mount in
/usr/bin now and a symlink in /bin pointing to /usr/bin.


> You missed what I said completely. You didn't create the NT attr,
> Samba did it on your behalf. Samba - the aplication that owns the
> xattr - has higher privileges than you do, and so it can do things
> you can't. Like manage attributes in the security namespace.
---

I didn't miss it -- I was talking about user-proxies.  The point of
my running a linux server as a Domain Controller is that I have 1 point
of security on my net -- the server, and whether I log in to a client
or the server, I "should" (conceptually) have access to the same files.

If I ssh from the client to the server, I see a message in messages:

    sshd accepted public key for Domain\\linda from [station]...

Samba provides user and group name resolution and security for the
server.


>> ====
>> As I tried to make clear -- this is a new behavior I'm seeing.  I've never
>> had attrs on my files that I, as the file 'owner' couldn't move around
>> to permitted locations.  As it is an ACL, my feeling is it should be
>> stored in the same way the posix acls are -- which are copyable.
> 
> Then something above the filesystem has changed. We haven't changed
> anything to do with who or how xattrs are stored or used in XFS for
> a long time.
----
	Neither the kernel nor xfs were high on my list of
candidates.
> 
> Cheers,
---
and felicitations!...

linda

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
