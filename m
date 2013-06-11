Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EBFE729DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 14:17:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C5C968F804B
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 12:17:17 -0700 (PDT)
Received: from mail-qc0-f176.google.com (mail-qc0-f176.google.com
	[209.85.216.176]) by cuda.sgi.com with ESMTP id
	JKWsCejQASidGQZO (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Jun 2013 12:17:16 -0700 (PDT)
Received: by mail-qc0-f176.google.com with SMTP id z10so548639qcx.35
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 12:17:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51B75E42.4070105@sandeen.net>
References: <loom.20130611T112155-970@post.gmane.org>
	<51B72D3D.5010206@redhat.com>
	<CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
	<51B75E42.4070105@sandeen.net>
Date: Tue, 11 Jun 2013 14:17:16 -0500
Message-ID: <CAO9HMNFj4Y8bEg3xZct0PTk_4wmGCtuNgFf4m4TR-PnZR_BrNQ@mail.gmail.com>
Subject: Re: Questions about XFS
From: Steve Bergman <sbergman27@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ric Wheeler <rwheeler@redhat.com>, xfs@oss.sgi.com

Eric,

Thank you for the straight answers to my questions, and for not trying
to argue with me about my real life experiences. I honestly appreciate
that.

All this information was very helpful. I've always been fuzzy about
the interaction between filesystem mount options, like commit=5, and
the vm tunables. So am I correct in thinking that
dirty_writeback_centisecs tells pdflush how often to wake up and look
around for data to flush. That the commit=5 mount parameter to extX
says "flush the journaled metadata to disk every 5 seconds, unless the
vm tells us to do it before that". And If I set commit=45, I'd still
get 30-35 second metadata flushes due to dirty_expire_centisecs=3000
and dirty_writeback_centisecs=500? And that that actual data will also
gets flusehd at least every 30-35 seconds for the same reasons?  And
that those vm parameters basically apply to XFS in the same way?
(Except XFS has some setting to flush metadata more frequently, I'd
guess.

I follow LWN, even though I rarely post anymore. I'd read that article
before. But I reviewed it again on (your?) recommendation, yesterday.
I think Ric recommended it to me, as well.

Now about ext3 behavior. (Sorry, I know this is an XFS list, but I've
been dying to have this clarified. And this does kind of relate to
XFS.) Not only does data get flushed more frequently. But it gets
careful treatment. It gets written out immediately before the
metadata. But both are (almost?) always written at almost exactly the
same time. Obviously, this comes with a significant performance price
tag for the whole system, which understandably upsets a lot of people.
But more than just the more frequent data updates, doesn't that
contribute substantially to ext3's pony-magic? The reason that I'm
particularly interested in this is that I don't really care that much
whether I lose 5 seconds of data or 30 seconds of data. That doesn't
make much difference. What I do care about is losing a whole day's
worth of data. And I have definitely observed a difference here
between ext3 & ext4. (And I'm assuming XFS would act very much like
ext4 in this context.) What happens with ext4, but *never* in my
experience with ext3 (though I acknowledge that it's *possible* and
just a matter of relative likelihood) is that I end up with C/ISAM
(not database!) files that were being appended to that are not just
missing data at the end, but are actually corrupted. Sometimes in such
a way that the rebuild utility cannot repair them and everything is
lost. This is not common. But I've seen it happen a couple of times
since I've been using ext4. Is the careful ordering, and the fact that
metadata is always written at the same time (and just after the data)
in ext3 likely to be responsible for that difference?

-Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
