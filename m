Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0DBE37F76
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 00:09:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EEF168F8050
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 22:09:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mKRpVCd9jK4dYaqu for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 22:09:04 -0700 (PDT)
Message-ID: <540FDCF4.3020202@sandeen.net>
Date: Wed, 10 Sep 2014 00:09:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Corrupted files
References: <540F1B01.3020700@mygrande.net>	<CAA43vkXwHF9RHW-cbTZ91_vF6wiQ6o_+TQDL3=7kD9P4tErCNQ@mail.gmail.com>	<CAA43vkWgh8-EjDXjkySUn+y18W1O+v_W5j+fQankRTgDCmc8tw@mail.gmail.com>	<540F7E37.7020500@sandeen.net>
	<CAA43vkX8Ve3g7=w16742b4vT3=yRdCMR7m66g2M7fYPmEMmctA@mail.gmail.com>
In-Reply-To: <CAA43vkX8Ve3g7=w16742b4vT3=yRdCMR7m66g2M7fYPmEMmctA@mail.gmail.com>
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
To: Sean Caron <scaron@umich.edu>
Cc: Leslie Rhorer <lrhorer@mygrande.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 9/9/14 5:57 PM, Sean Caron wrote:
> Hey, just sharing some hard-won (believe me) professional experience.
> I have seen xfs_repair take a bad situation and make it worse many
> times. I don't know that a filesystem fuzzer or any other simulation
> can ever provide true simulation of users absolutely pounding the tar
> out of a system. There seems to be a real disconnect between what
> developers are able to test and observe directly, and what happens in
> the production environment in a very high-throughput environment.
>
> Best,
>
> Sean

Fair enough, but I don't want to let stand an assertion that you should
avoid xfs_repair at all (most) costs.  It, like almost any software,
has some bugs, but they don't get fixed if they don't get well reported.
We do our best to improve it when we get useful reports from
users - usually including a metadata dump - and we beat on it as best
we can in the lab.

"pounding the tar out of a filesystem" should not, in general, require
an xfs_repair run.  ;)

Yes, it's always good advice to do a dry run before committing to a
repair, in case something goes off the rails.  But most times I've seen
things go very very badly was when the storage device under the filesystem
was no longer consistent, and the filesystem really had no pieces to
pick up.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
