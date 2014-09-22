Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C61DF7F53
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 09:56:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B53728F8035
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 07:56:18 -0700 (PDT)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
	cuda.sgi.com with ESMTP id vwhYS5lgVe8VBt27 for
	<xfs@oss.sgi.com>; Mon, 22 Sep 2014 07:56:17 -0700 (PDT)
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
References: <20140918195650.GI19952@sgi.com>
Date: Mon, 22 Sep 2014 07:55:59 -0700
In-Reply-To: <20140918195650.GI19952@sgi.com> (Ben Myers's message of "Thu, 18
	Sep 2014 14:56:50 -0500")
Message-ID: <87lhpbhfgg.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
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
Cc: linux-fsdevel@vger.kernel.org, tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

Ben Myers <bpm@sgi.com> writes:
>
> Strings are normalized using a trie that stores the relevant
> information.  The trie itself is about 250kB in size, and lives in a
> separate module.

So 250kB bloat -- and what does this fix exactly?

Someone putting random ligatures into their file names and expecting
the file to be the same as before. Can't they just not do that?

-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
