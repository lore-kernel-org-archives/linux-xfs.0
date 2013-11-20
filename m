Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A73227F51
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 23:19:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 95086304043
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 21:19:07 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id dYN8ejAPAHVSdYnc for <xfs@oss.sgi.com>;
	Tue, 19 Nov 2013 21:19:06 -0800 (PST)
References: <CAH2r5msswZg_NvY9qMNknh2FWht1jMgwW1s2umtaBj3mHreDAw@mail.gmail.com>
	<20131116145507.GA22395@infradead.org>
	<CAH2r5mtXjnAOpKzZzta_yWDGyEPzR7h1wb0UW2pnoicm9Qsgxg@mail.gmail.com>
	<20131118152723.GA19649@infradead.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20131118152723.GA19649@infradead.org>
Message-Id: <393B44C2-4609-4E05-8B21-4CC12056F9A6@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: setfacl fix
Date: Tue, 19 Nov 2013 23:19:01 -0600
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Steve French <smfrench@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, samba-technical <samba-technical@lists.samba.org>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>

On Nov 18, 2013, at 9:27 AM, Christoph Hellwig <hch@infradead.org> wrote:
> 
>> On Sat, Nov 16, 2013 at 03:38:09PM -0600, Steve French wrote:
>> Makes sense to add a setfacl/getfacl test to xfstest and was trying to
>> build updated xfstests and look at what has changed but ran into a
>> strange error building xfstests and didn't see an obvious answer when
>> googling for it.  Any idea how to workaround the build failure?
>> 
>> Building src
>>    [DEP]
>>    [CC]    dirstress
>> gcc: error: /lib64/libhandle.so: Too many levels of symbolic links
>> 
>> 
>> These are the steps I went through from a fairly clean Fedora 19 64
>> system before the make failure:
> 
> No idea.  Maybe some of the RedHat people on the xfs list have more
> experience with Fedora than I have.
> 
Just FWIW fedora has xfsprogs-devel and xfsprogs-qa-devel rpms which should satisfy xfstests for that part of the deps.  I've not done a qa-install manually on fedora since forever...

Eric
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
