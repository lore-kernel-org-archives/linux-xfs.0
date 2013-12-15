Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B0B207F52
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 08:22:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9F40F8F804B
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 06:21:59 -0800 (PST)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id ldZGJ7gEx4TDbZfX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 15 Dec 2013 06:21:57 -0800 (PST)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id
	rBFELrdA005031 for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 06:21:55 -0800
Message-ID: <52ADBB00.8050707@tlinx.org>
Date: Sun, 15 Dec 2013 06:21:52 -0800
From: "L.A. Walsh" <samba@tlinx.org>
MIME-Version: 1.0
Subject: Re: BTW - to xfs folk,
	'security attr' doesn't seem very useful w/current copy policies
References: <52A96211.3050602@tlinx.org>
	<20131212181315.GB20500@samba2>	<52AAC7CC.8000802@tlinx.org>
	<20131213105314.GA2117@infradead.org> <52AB7CDC.5040801@tlinx.org>
In-Reply-To: <52AB7CDC.5040801@tlinx.org>
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
To: xfs-oss <xfs@oss.sgi.com>



On 12/13/2013 1:32 PM, L.A. Walsh wrote:
> On 12/13/2013 2:53 AM, Christoph Hellwig wrote:
> > On Fri, Dec 13, 2013 at 12:39:40AM -0800, L.A. Walsh wrote:
> >  
> >>    Does it have to be under a "namespace" that gets *stripped*
> >> as soon as the file is copied or "mv'd to another
> >> samba share (i.e. the partition it was moved to is shared with the
> >> same permissions as the first one.
> >
> > Attributes never get "stripped", they simple don't get copied unless
> > explicit action is taken to do so.  Setting trusted attributes up on a
> > new file will of course rely privilegues, exactly for the reasons
> > Jeremy pointed out.
-----
For what purpose?  As it stands the security namespace doesn't seem
very useful -- i.e. the 'root' attrs get copied and/or moved on a file
copy/rename which carries the access along with the file contents.

But I fail to see the usefulness in having a security namespace that
is dropped by default on copies or inter-partition moves.

Shouldn't it follow along and be copied much as are the root namespace
entries?

It gets really confusing if a "proxy service" (ex. file server)
for the user, stores attributes in that namespace thinking they will
somehow be useful when the user accesses the file w/o the proxy service --
i.e. as a normal file.

Was there a specific use-case for being able to tag files with security
attrs that can't be copied, moved or renamed except by root that wouldn't
better be served by signed or 'sealed' (encrypted) content?  For most
cases, it would seem that signing to detect tampering would be enough,
though I can think of cases where sealing to prevent knowledge of
who has what access would also be useful.

Something to think about before others try to use the security field to
store attrs they want kept with the content and not the inode.




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
