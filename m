Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAQ8kCXY170493 for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 02:46:12 -0600
Received: from fgwmail5.fujitsu.co.jp (fgwmail5.fujitsu.co.jp [192.51.44.35])
	by cuda.sgi.com with ESMTP id BOQBPk2miXDQwXwd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Nov 2012 00:48:27 -0800 (PST)
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id E59AA3EE0BC
	for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 17:48:25 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id CD1B645DE4F
	for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 17:48:25 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id B3E2F45DE4E
	for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 17:48:25 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id A55FA1DB803B
	for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 17:48:25 +0900 (JST)
Received: from g01jpexchkw32.g01.fujitsu.local
	(g01jpexchkw32.g01.fujitsu.local [10.0.193.115])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 5FC771DB802F
	for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 17:48:25 +0900 (JST)
Message-ID: <50B32CC1.3020907@jp.fujitsu.com>
Date: Mon, 26 Nov 2012 17:48:01 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [BUG] xfs_quota: can't handle the users managed by LDAP
References: <50ADB27F.8070806@jp.fujitsu.com> <20121122233757.GY2591@dastard>
In-Reply-To: <20121122233757.GY2591@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs ML <xfs@oss.sgi.com>

(2012/11/23 8:37), Dave Chinner wrote:
> On Thu, Nov 22, 2012 at 02:05:03PM +0900, Satoru Takeuchi wrote:
>> Hi,
>>
>> Current xfs_quota (I pulled xfsprogs today) seems not be able to the users
>> managed by LDAP. There is no patch since I'm not good at LDAP and don't know
>> the root cause yet ;-(
>>
>> Step to reproduce(in this case, "sat" is the user managed by LDAP):
>> ===============================================================================
>> # uname -r
>> 3.7.0-rc5
>> # mount -o loop,usrquota xfs.img mnt
>> # xfsprogs/quota/xfs_quota -xc "limit bsoft=10M bhard=10M sat" /dev/loop0
>> xfs_quota: invalid user name: sat                                          # denied
>> # su sat
>> $                                                                          # But this user acutally exists.
>> ===============================================================================
>>
>> The kernel is a bit old, but I suspect this is a userland problem.
> 
> Yes, userland.
> 
> However, xfs_quota is not supposed to know about LDAP, or NIS, or
> any other user database. It uses the getpwnam() to convert the user
> name to a UID, and that call is failing to find "sat". This is
> supposed to work with LDAP (as mentioned in the man page), and if it
> isn't it generally means something is broken with your LDAP setup
> (/etc/nsswitch.conf not correct?) rather than there being something
> wrong with xfs_quota....

Probably this behaivor comes from the difference between the test machine
and the build machine which I built the upstream xfsprogs.

I made the following simple program which just calls getpwnam().

===============================================================================
#include <sys/types.h>
#include <pwd.h>
#include <err.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
        struct passwd *p;
        if ((p = getpwnam("sat")) == NULL)
                err(EXIT_FAILURE, "getpwnam() failed.");
        printf("name = %s, id = %d\n", p->pw_name, p->pw_uid);
        exit(EXIT_SUCCESS);
}
===============================================================================

Here is the result of this problem at the test machine.

 - SUCCEEDED: build at the test machine
 - FAILED: built at the build machine

I will build xfsprogs at the test machine and confirm whether this behavior
(getpwnam() fails) happens or not again.

Thanks,
Satoru


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
