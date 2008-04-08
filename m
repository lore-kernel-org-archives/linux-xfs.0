Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 23:49:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m386mmmc024801
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 23:48:52 -0700
Date: Tue, 08 Apr 2008 16:50:26 +1000
Subject: Re: [REVIEW] cleanup - remove bhv_vname_t
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.t89zp3j63jf8g2@pc-bnaujok.melbourne.sgi.com> <20080408063822.GA21876@infradead.org>
Message-ID: <op.t895ac193jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080408063822.GA21876@infradead.org>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, 08 Apr 2008 16:38:22 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Tue, Apr 08, 2008 at 02:50:17PM +1000, Barry Naujok wrote:
>> -
>> +
>
> What's this?  both lines look empty.

The first had a tab, my editor automatically cleans whitespace from
the end of lines. Two cases of that in this patch.

>>  	return -dm_send_namesp_event(event, mp ? mp->m_super : NULL,
>>  				    ip1->i_vnode, vp1_right,
>>  				    ip2 ? ip2->i_vnode : NULL, vp2_right,
>> -				    name1, name2,
>> +				    (char *)name1, (char *)name2,
>
> please change dm_send_namesp_event to take a const char aswell.

Noooo :)

>> +static inline struct xfs_name *
>> +xfs_dentry_name(
>> +	struct xfs_name	*namep,
>> +	struct dentry	*dentry)
>> +{
>> +	namep->name = dentry->d_name.name;
>> +	namep->len = dentry->d_name.len;
>> +	return namep;
>> +}
>
> As mentioned in my comment to the CI series:  shouldn't you just use
> a struct qstr instead of adding a new struct xfs_name?

Keeping a clean line between fs/xfs and fs/xfs/linux-2.6.

> Also please don't add inline for this.
>> +xfs_name_t xfs_name_dotdot = {"..", 2};
>
> const?

I should change all calls using xfs_name to use const xfs_name?

>> +	args.name = name->name;
>> +	args.namelen = name->len;
>> +	args.hashval = xfs_da_hashname(name->name, name->len);
>
> What about just putting a pointer to the xfs_name/qstr into args?

As Dave said, for another cleanup patch :)
