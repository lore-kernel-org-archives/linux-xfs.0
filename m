Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D9C77F78
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 05:14:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1D927AC004
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 03:14:22 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 8tj0F7f2wUXJDDcy
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 03:14:18 -0700 (PDT)
Message-ID: <51483A7D.9050202@hardwarefreak.com>
Date: Tue, 19 Mar 2013 05:14:21 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Xfs_repair and journalling
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<5147E360.10605@sandeen.net> <5148037B.5010706@hardwarefreak.com>
	(sfid-20130319_091205_759083_BA6F1AD2)
	<201303190924.29362.Martin@lichtvoll.de>
In-Reply-To: <201303190924.29362.Martin@lichtvoll.de>
Reply-To: stan@hardwarefreak.com
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
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Eric Sandeen <sandeen@sandeen.net>, Subranshu Patel <spatel.ml@gmail.com>, xfs@oss.sgi.com

On 3/19/2013 3:24 AM, Martin Steigerwald wrote:
> Am Dienstag, 19. M=E4rz 2013 schrieb Stan Hoeppner:
>> Martin, I didn't state that ext4 cannot perform journal recovery, which
>> you previously misunderstood.  As mentioned above I stated it made a
>> call to e2fsck to perform the task.  And, again, apparently this is not
>> the case.  If you want to excoriate me for getting this wrong, that's
>> fine.  But don't do it in a way that suggests it was intentional, or
>> that I made no effort to verify the information before I stated it.  I
>> spent at least 30 minutes Googling trying to track down documents
>> explaining the ext4 journal recovery code in the kernel.  I simply
>> didn't find any.  The only thing I found were descriptions of e2fsck
>> based journal recovery.
> =

> Stan, you are still a XFS expert, you are still a hardware expert, and I =

> love reading your posts at debian-user, I sometimes even search for those=
, =

> you still know a lot and heck you are still Stan and as such without any =

> achievement or knowledge at all a precious being.

Thank you for the kind words.  I'm far from an XFS expert.  I may
understand parts of it better than some other users, but my knowledge of
it is laughably tiny and woefully incomplete compared to any of the
developers, who are the subject matter experts.  Which is why I
regularly ask Dave to elaborate on things of which I don't yet have
knowledge or understanding.  He explains things in a way that I can
easily digest.  Kudos to Dave for being a good teacher.

> Just like anyone else on this list (and elsewhere) is a precious being ju=
st =

> as they are.
> =

> So whats so difficult with admitting that what you wrote about Ext4 and =

> journal replay as at least misleading?

I thought I did in my last reply, 3 paragraphs above the one you pasted
above.  I said:

"...if this code is duplicated in the EXT4 kernel driver, then my
apologies for spreading misinformation due to being misinformed...."

> Heck, even I was confused at first. Cause the manpage of fsck.ext4 IMHO i=
s =

> not really clear about that topic to say the least. I tested it out for a =

> reason.

I already contacted Ted off list hoping he can point me to the relevant
kernel documentation, so I don't make such a mistake again with EXT.

> I am concerned about the tendency I perceive in open source, heck general =

> computer communities to bind own value to being right on a topic. There i=
s =

> no, absolutely no connection at all. You and everyone else is valuable an=
d =

> precious without any prerequisite at all.

I'm less concerned about "being right" than "getting it right".  When I
make a mistake like this it's rather embarrassing.  So I do my best to
correct the mistake, by learning the relevant information, and not
making the mistake again.

> I also take some to learn out of this myself: Cause I was obsessed with =

> being right myself and bound my value to it as well. I have overdone my =

> previous mails. Sorry for that.

The part you're referring to wasn't about being right, but merely
clarifying what occurred in the thread.  I stated incorrect information,
then the OP repeated it but in a way that made what I said even more
incorrect.  In other words, I was telling Eric this was my fault.  I.e.
taking responsibility for the mistake, that then snowballed.  I wouldn't
call that "being obsessed with being right".  I was wrong and clearly
stated so.

Anyway, too much text/time/bandwidth has been wasted on this already.
Let's move on to something else.  If I'm able to get hold of some good
ext4 kernel documentation describing the journal handlig I'll gladly share.

-- =

Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
