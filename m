Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Mar 2008 20:05:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2N35LKE015797
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 20:05:23 -0700
Received: from rv-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C24B26D6B37
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 20:05:54 -0700 (PDT)
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.185]) by cuda.sgi.com with ESMTP id ICV1Gpcsi2OU5hYg for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 20:05:54 -0700 (PDT)
Received: by rv-out-0910.google.com with SMTP id k20so1165563rvb.32
        for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 20:05:54 -0700 (PDT)
Message-ID: <47E5C90F.70303@gmail.com>
Date: Sun, 23 Mar 2008 11:05:51 +0800
From: Kevin Xu <cgxu.gg@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH]fix the algorithm for addname in xfs_da_node_lookup_int
References: <47E5AC7D.4080708@gmail.com> <47E5B64E.5090504@sandeen.net>
In-Reply-To: <47E5B64E.5090504@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfscn@googlegroups.com, xfs@oss.sgi.com

Eric Sandeen wrote:
> Kevin Xu wrote:
>   
>> fix the algorithm for addname in xfs_da_node_lookup_int
>>     
>
> Could you please include a bit more of a changelog, i.e. what was broken
> and how does this fix it?  Perhaps a testcase, if there is one?
>
> -Eric
>
>   
I think there is a problem in original processing.
When add a new entry and its hash value is already exist in current 
directory, furthermore the hash value
is the last one in a leaf block, although we already found a freespace 
block for adding the new entry,
but we drop this one and continue to check, until the last same hash value.
I think the reason is that xfs_da_node_lookup_int is a common function 
for addname and lookup.


I added a condition before enter another leaf block, only when we didn't 
find a freespace block for the new entry,
then we need to enter another leaf block.

Regards
Kevin
