Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E7F7F7F47
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2014 17:08:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 81F3EAC001
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2014 15:08:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sOQOobJgtcuujkiI for <xfs@oss.sgi.com>;
	Sat, 05 Jul 2014 15:08:18 -0700 (PDT)
Message-ID: <53B87752.9000008@sandeen.net>
Date: Sat, 05 Jul 2014 17:08:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Data loss XFS with RT kernel on Debian.
References: <CAA85NCjXU7rK8C4AcQ4Tnxowx5MFBUyAoLW_nuwmKyOFL-_PgQ@mail.gmail.com>
	<53B85AB0.30800@sandeen.net>
In-Reply-To: <53B85AB0.30800@sandeen.net>
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
To: Jan de Kruyf <jan.de.kruyf@gmail.com>, xfs@oss.sgi.com

On 7/5/14, 3:06 PM, Eric Sandeen wrote:
> On 7/5/14, 7:41 AM, Jan de Kruyf wrote:
>> Hallo,
>>
>> While doing a reasonably high density job like rsynching a
>> subdirectory from one place to another, or tarring it to a pipe and
>> untarring it at the other end, I note that the cpu usage goes
>> practically to 100% and when I after 5 minutes or so I reset the
>> computer the writing has not finished at all. However on the stock
>> Debian kernel it works without a problem.
>> 
>> Could I still use this combination in an industrial environment
>> reading and writing reasonably short text files? So far I did not
>> experience this problem with normal day to day use. It stuck up its
>> head during installation of gnat-gpl-2014-x86_64-linux-bin from the
>> http://libre.adacore.com/download/ page. The offending code is in
>> the Makefile in the top directory page. The Xterm will give you the
>> place where it gets stuck.

> http://lwn.net/Articles/457667/

Ok, sorry - that was a little short ;)

If you have some 100% cpu livelock or whatever, that does sound like
a potential bug.  Perhaps some tracing or profiling can help figure
out what has gone wrong there.  Maybe sysrq-t & see where the active
threads are, or even top?

But if you are surprised that you lost data when you did a hard reset,
the URL above is informative.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
