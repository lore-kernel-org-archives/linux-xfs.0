Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 705CF7F5D
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 11:10:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5D68C8F8039
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 09:10:47 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qtELVN4oKMIEvUBN for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 09:10:46 -0800 (PST)
Message-ID: <5106B115.3080203@sandeen.net>
Date: Mon, 28 Jan 2013 11:10:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Volume fine on x86_64, corruption on ARM
References: <20130127225258.GA2287@vicerveza.homeunix.net>
	<51065721.40102@hardwarefreak.com>
	<20130128133759.GH2287@vicerveza.homeunix.net>
In-Reply-To: <20130128133759.GH2287@vicerveza.homeunix.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?ISO-8859-1?Q?Llu=EDs_Batlle_i_Rossell?= <viric@viric.name>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On 1/28/13 7:37 AM, Llu=EDs Batlle i Rossell wrote:
> On Mon, Jan 28, 2013 at 04:46:57AM -0600, Stan Hoeppner wrote:
>> On 1/27/2013 4:52 PM, Llu=EDs Batlle i Rossell wrote:
>>
>>> ----------------------
>>> starting systemd...
>>> systemd 197 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX +IMA=
 +SYSVINIT -LIBCRYPTSETUP +GCRYPT +ACL +XZ)
>>>
>>> Welcome to NixOS 0.2pre-4eb2b09-af495e0!
>>>
>>> Failed to insert module 'autofs4'
>>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>> dea96000: 58 46 53 42 00 00 10 00 00 00 00 00 01 bd 26 f0  XFSB........=
..&.
>>> XFS (sda1): Internal error xfs_da_do_buf(2) at line 2192 of file fs/xfs=
/xfs_da_btree.c.  Caller 0xbf057e68
>> ...
>> Your HDD is USB.  Might the failure of this module to load have
>> something to do with the XFS problems?

I doubt it.

> I don't think it is related; the failure to load the module is because the
> module isn't there in my kernel. And that happens after the fs has been q=
uite
> used in the boot, it's not mount time.
> =

>> Forgive me if my lack of experience with this is causing me to ask a
>> stupid question.  I've never used, nor will I ever use, XFS with a USB
>> drive.
> =

> Well, I didn't expect it to be any trouble :) I've XFS in other USB drive=
s, but
> before this, I only used them in x86_64. I might stop using XFS there.

It should work, and I'd like to find out why it's not.  It used to.  :)

But I'm a little low on time.  Would you be willing to spot-check some older
kernels, and see if/when this regressed?

Thanks,
-Eric

> Thank you,
> Llu=EDs.
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
