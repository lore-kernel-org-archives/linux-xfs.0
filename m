Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D332A7F3F
	for <linux-xfs@oss.sgi.com>; Fri, 19 Jul 2013 18:35:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C384D304062
	for <linux-xfs@oss.sgi.com>; Fri, 19 Jul 2013 16:34:59 -0700 (PDT)
Subject: Re: [PATCH] xfs_metadump: manpage fix regarding frozen fs
References: <51E4AD14.7080904@redhat.com> <20130719202055.GH3572@sgi.com>
From: Eric Sandeen <esandeen@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20130719202055.GH3572@sgi.com>
Message-Id: <87CEB35B-5931-49C9-8075-F44851F6E8ED@redhat.com>
Date: Fri, 19 Jul 2013 19:34:57 -0400 (EDT)
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
To: Ben Myers <bpm@sgi.com>
Cc: "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>, Eric Sandeen <sandeen@redhat.com>

On Jul 19, 2013, at 3:20 PM, Ben Myers <bpm@sgi.com> wrote:

> Hey Eric,
> 
> On Mon, Jul 15, 2013 at 09:16:52PM -0500, Eric Sandeen wrote:
>> The xfs_metadump manpage states that metadump works
>> on a frozen filesystem; it does not.  In fact, there is
>> no way to detect a frozen filesystem, so we can't make it
>> work, either.
>> 
>> So just remove this from the manpage; unmounted or RO
>> mounted is what is enforced by xfs_metadump.
>> 
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> I gave this a try and it *seemed* to work fine on a frozen filesystem.
> Can you provide a bit of detail about why xfs_metadump doesn't work on
> frozen filesystems?  What am I missing?
> 

Hum, when I tried it it didn't work.  I can retest, but AFAIK there is no way to detect a frozen fs in the first place, so how could it work?

-Eric

> Thanks,
>    Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
